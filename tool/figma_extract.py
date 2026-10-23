"""Figma dev-export text extractor for TankerTrack R3.
Reads each screen JSON under docs/reference/figma/pkg-*/screens/*/*.json,
walks `nodes` recursively collecting TEXT nodes, annotation frames,
companion-state / action-outcome frames, assetIndex, and numbers.
Writes docs/plan/figma-content/<ID>.md per exported screen (exact copy, no retyping).
Usage: py -3 tool/figma_extract.py
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIGMA = ROOT / "docs" / "reference" / "figma"
OUTDIR = ROOT / "docs" / "plan" / "figma-content"

NUM_RE = re.compile(r"\d[\d,]*(?:\.\d+)?\s*(?:IG|L|km|KM|min|mins|%|AED|X)?")


def iter_text_nodes(node, trail, out):
    ntype = node.get("type")
    name = node.get("name", "")
    path = trail + [name]
    chars = None
    # Figma dev-export TEXT nodes carry `characters` and/or `textContent`
    for key in ("characters", "charactersWithStyle", "textContent", "text"):
        if key in node and isinstance(node[key], str) and node[key].strip():
            chars = node[key]
            break
    # styleOverrideTable-based characters
    if chars is None and "characterStyles" in node:
        pass
    if ntype == "TEXT":
        style = node.get("style", {})
        out.append({
            "path": " / ".join(path),
            "name": name,
            "chars": node.get("characters", node.get("textContent", "")),
            "fontSize": (style.get("fontSize") if isinstance(style, dict) else node.get("fontSize")),
        })
    for ch in node.get("children", []) or []:
        iter_text_nodes(ch, path, out)


def find_frames_by(node, pred, trail, out):
    path = trail + [node.get("name", "")]
    if pred(node.get("name", "")):
        out.append({"path": " / ".join(path), "id": node.get("id", "")})
    for ch in node.get("children", []) or []:
        find_frames_by(ch, pred, path, out)


def extract_screen(json_path: Path):
    d = json.loads(json_path.read_text(encoding="utf-8"))
    ds = d.get("developerSummary", {}) or {}
    screen = ds.get("screen", {}) or {}
    rep = ds.get("representativeText", []) or []
    impl = ds.get("implementationGuidance", []) or []
    warns = ds.get("warnings", []) or []
    nodes = d.get("nodes", []) or []
    asset_index = d.get("assetIndex", d.get("assetManifest", None))
    texts = []
    for n in nodes:
        iter_text_nodes(n, [], texts)
    annotations, companions, outcomes = [], [], []
    for n in nodes:
        find_frames_by(n, lambda s: "annotation" in s.lower(), [], annotations)
        find_frames_by(n, lambda s: "companion" in s.lower(), [], companions)
        find_frames_by(n, lambda s: "action outcome" in s.lower(), [], outcomes)
    return {
        "screen": screen, "rep": rep, "impl": impl, "warns": warns,
        "texts": texts, "annotations": annotations, "companions": companions,
        "outcomes": outcomes, "assetIndex": asset_index, "raw": d,
    }


def screen_id_from_name(name: str, json_path: Path) -> str:
    m = re.match(r"\s*([A-Z]+-\d+|00|H-\d+)\b", name.strip())
    if m:
        tok = m.group(1)
        if tok == "00":
            return "OVERVIEW"
        return tok
    stem = json_path.stem
    m2 = re.match(r"([A-Z]+-\d+|00_Overview[^.]*)", stem)
    return m2.group(1) if m2 else stem


def md_for(sid, sname, json_path, png_rel, pkg, ext):
    lines = []
    lines.append(f"# {sid} — {sname}")
    lines.append("")
    lines.append(f"- Source JSON: `{json_path.as_posix()}`")
    lines.append(f"- Preview PNG: `{png_rel}`")
    lines.append(f"- Package: `{pkg}`")
    lines.append(f"- Frame: {ext['screen'].get('width','?')}x{ext['screen'].get('height','?')} node {ext['screen'].get('id','?')}")
    lines.append(f"- Extraction: script `tool/figma_extract.py` (exact copy of TEXT nodes; order = Figma tree order)")
    lines.append("")
    lines.append("## 1. Representative text (developerSummary.representativeText, verbatim)")
    lines.append("")
    if ext["rep"]:
        for t in ext["rep"]:
            lines.append("```text")
            lines.append(str(t))
            lines.append("```")
    else:
        lines.append("_none_")
    lines.append("")
    lines.append("## 2. Full text-node copy (every TEXT node, verbatim)")
    lines.append("")
    lines.append(f"_TEXT node count: {len(ext['texts'])}_")
    lines.append("")
    for i, t in enumerate(ext["texts"], 1):
        chars = (t["chars"] or "").replace("\r", "")
        lines.append(f"### 2.{i} `{t['name']}`")
        lines.append(f"_path: {t['path']}_")
        lines.append("```text")
        lines.append(chars)
        lines.append("```")
    lines.append("")
    lines.append("## 3. Screen annotation frame(s)")
    lines.append("")
    for a in ext["annotations"]:
        lines.append(f"- `{a['path']}` (id {a['id']})")
    if not ext["annotations"]:
        lines.append("_none found_")
    lines.append("")
    lines.append("## 4. Action → outcome frame(s)")
    lines.append("")
    for a in ext["outcomes"]:
        lines.append(f"- `{a['path']}` (id {a['id']})")
    if not ext["outcomes"]:
        lines.append("_none found_")
    lines.append("")
    lines.append("## 5. Companion-state specimens (4 states)")
    lines.append("")
    for a in ext["companions"]:
        lines.append(f"- `{a['path']}` (id {a['id']})")
    if not ext["companions"]:
        lines.append("_none found_")
    lines.append("")
    lines.append("## 6. Every data point / number (regex scan over text nodes)")
    lines.append("")
    seen = []
    for t in ext["texts"]:
        for m in NUM_RE.finditer(t["chars"] or ""):
            v = m.group(0).strip()
            if v and v not in seen:
                seen.append(v)
    if seen:
        for v in seen:
            lines.append(f"- `{v}`")
    else:
        lines.append("_no numbers detected_")
    lines.append("")
    lines.append("## 7. Assets referenced by this screen")
    lines.append("")
    ai = ext["assetIndex"]
    try:
        if isinstance(ai, dict) and "items" in ai:
            for it in ai["items"]:
                lines.append(f"- `{it.get('fileName','?')}` ({it.get('width','?')}x{it.get('height','?')}, {it.get('byteLength','?')} bytes, role={it.get('semanticRole','?')}, node=`{it.get('nodeName','?')}`)")
        elif isinstance(ai, dict):
            lines.append("```json")
            lines.append(json.dumps(ai, indent=1, ensure_ascii=False)[:3000])
            lines.append("```")
        else:
            lines.append("_see screen assets/ manifest_")
    except Exception as e:  # noqa: BLE001
        lines.append(f"_asset index render error: {e}_")
    lines.append("")
    lines.append("## 8. Implementation guidance + warnings (verbatim)")
    lines.append("")
    for g in ext["impl"]:
        lines.append(f"- {g}")
    for w in ext["warns"]:
        lines.append(f"- WARNING: {w}")
    lines.append("")
    return "\n".join(lines) + "\n"


def main():
    OUTDIR.mkdir(parents=True, exist_ok=True)
    screens = sorted(FIGMA.glob("pkg-*/screens/*/*.json"))
    print(f"found {len(screens)} screen JSON files")
    index = []
    for jp in screens:
        try:
            ext = extract_screen(jp)
        except Exception as e:  # noqa: BLE001
            print(f"FAIL {jp}: {e}", file=sys.stderr)
            continue
        sname = ext["screen"].get("name") or jp.stem
        sid = screen_id_from_name(sname, jp)
        pkg = jp.parts[jp.parts.index("figma") + 1]
        png = jp.with_name(jp.stem + "@2x.png")
        try:
            png_rel = png.relative_to(ROOT).as_posix()
        except ValueError:
            png_rel = png.as_posix()
        try:
            jrel = jp.relative_to(ROOT).as_posix()
        except ValueError:
            jrel = jp.as_posix()
        md = md_for(sid, sname, Path(jrel), png_rel, pkg, ext)
        out = OUTDIR / f"{sid}.md"
        out.write_text(md, encoding="utf-8")
        index.append((sid, sname, jrel, png_rel, len(ext["texts"])))
        print(f"wrote {out.name} ({len(ext['texts'])} text nodes)")
    idx = OUTDIR / "_index.txt"
    idx.write_text("\n".join(f"{a} | {b} | {c} | {e} texts" for a, b, c, d_, e in index), encoding="utf-8")
    print(f"index: {len(index)} screens -> {idx}")


if __name__ == "__main__":
    main()

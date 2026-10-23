// svgo settings (P1c illustration pipeline).
// - keep viewBox (flutter_svg needs it for sizing)
// - keep placeholder fills (#TT_*) intact (string-replaced at load time)
// - strip editor metadata, comments, raster references fail the weight test
export default {
  multipass: true,
  plugins: [
    {
      name: 'preset-default',
      params: {
        overrides: {
          removeViewBox: false,
          // keep IDs referenced by url(#..) fills/clips
          cleanupIds: false,
        },
      },
    },
    'removeDimensions',
    { name: 'removeAttrs', params: { attrs: '(data-.*|sketch.*|inkscape.*)' } },
  ],
};

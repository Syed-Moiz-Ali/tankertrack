/// Roles mirror FRS §4. Navigation guards + RoleGate read this matrix.
enum Role {
  admin,
  sales,
  dispatcher,
  fleetController,
  driver,
  supervisor,
  finance,
  customerStub,
}

/// Least-privilege permissions.
enum Permission {
  ordersCreate,
  ordersView,
  dispatchAssign,
  dispatchOverride,
  fleetManage,
  inspectionReview,
  incidentManage,
  ledgerAdjust,
  reportsView,
  financeView,
  usersManage,
  configManage,
  auditView,
  driveTasks,
  approveVariance,
  closeTrip,
}

const Map<Role, Set<Permission>> rolePermissions = {
  Role.admin: {
    Permission.ordersCreate,
    Permission.ordersView,
    Permission.dispatchAssign,
    Permission.dispatchOverride,
    Permission.fleetManage,
    Permission.inspectionReview,
    Permission.incidentManage,
    Permission.ledgerAdjust,
    Permission.reportsView,
    Permission.financeView,
    Permission.usersManage,
    Permission.configManage,
    Permission.auditView,
    Permission.approveVariance,
    Permission.closeTrip,
  },
  Role.sales: {Permission.ordersCreate, Permission.ordersView},
  Role.dispatcher: {
    Permission.ordersView,
    Permission.dispatchAssign,
    Permission.incidentManage,
  },
  Role.fleetController: {
    Permission.ordersView,
    Permission.fleetManage,
    Permission.inspectionReview,
    Permission.incidentManage,
  },
  Role.driver: {Permission.driveTasks},
  Role.supervisor: {
    Permission.ordersView,
    Permission.dispatchOverride,
    Permission.reportsView,
    Permission.auditView,
    Permission.approveVariance,
    Permission.closeTrip,
    Permission.incidentManage,
  },
  Role.finance: {
    Permission.ordersView,
    Permission.financeView,
    Permission.reportsView,
  },
  Role.customerStub: {Permission.ordersView},
};

extension RoleX on Role {
  bool can(Permission p) => rolePermissions[this]?.contains(p) ?? false;
}

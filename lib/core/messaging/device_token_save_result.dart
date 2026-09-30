enum DeviceTokenSaveStatus { saved, unauthenticated, missingToken, failed }

class DeviceTokenSaveResult {
  const DeviceTokenSaveResult(this.status);

  final DeviceTokenSaveStatus status;
}

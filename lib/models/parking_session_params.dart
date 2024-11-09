class ParkingSessionParams {
  final List<String> licensePlates;
  final String parkingLotId;

  ParkingSessionParams(this.licensePlates, this.parkingLotId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ParkingSessionParams &&
              runtimeType == other.runtimeType &&
              licensePlates == other.licensePlates &&
              parkingLotId == other.parkingLotId;

  @override
  int get hashCode => licensePlates.hashCode ^ parkingLotId.hashCode;
}

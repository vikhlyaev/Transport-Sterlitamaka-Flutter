import 'package:transport_sterlitamaka/models/track.dart';

class Tracks {
  Tracks({
    required this.clid,
    required this.tracks,
  });

  String clid;
  List<Track> tracks;

  Tracks.fromMap(Map<String, dynamic> map)
      : clid = map['clid'],
        tracks = (map['tracks'] as List).map((track) => Track.fromMap(track)).toList();

  Map<String, dynamic> toMap() => {'clid': clid, 'tracks': tracks.map((track) => track.toMap()).toList()};
}

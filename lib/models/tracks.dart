import 'package:transport_sterlitamaka/models/track.dart';

/// [Tracks] - класс для парсинга JSON-объекта, который приходит с сервера.
class Tracks {
  Tracks({
    required this.clid,
    required this.tracks,
  });

  String clid;
  List<Track> tracks;

  Tracks.fromMap(Map<String, dynamic> map)
      : clid = map['clid'] as String,
        tracks = (map['tracks'] as List)
            .map((track) => Track.fromMap(track as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toMap() =>
      {'clid': clid, 'tracks': tracks.map((track) => track.toMap()).toList()};
}

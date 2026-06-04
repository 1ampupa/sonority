import 'package:flutter/material.dart';

import 'package:sonority/core/songs/song.dart';

class SongListTile extends StatefulWidget {
  final Song song;
  final bool isCurrentSong;
  final int index;
  final VoidCallback onTap;

  const SongListTile({
    super.key,
    required this.song,
    required this.isCurrentSong,
    required this.index,
    required this.onTap,
  });

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.isCurrentSong
          ? SizedBox(
              width: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.music_note)],
              ),
            )
          : SizedBox(
              width: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text((widget.index + 1).toString()),
                  SizedBox(width: 5),
                ],
              ),
            ),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: "IBM Plex Sans Thai",
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(widget.song.title),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontFamily: "IBM Plex Sans Thai",
        overflow: TextOverflow.ellipsis,
        color: Theme.of(context).colorScheme.secondary,
      ),
      subtitle: Text(widget.song.artist),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontFamily: "IBM Plex Sans Thai",
        overflow: TextOverflow.ellipsis,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.75),
      ),
      trailing: Text(widget.song.readableDuration),
      selected: widget.isCurrentSong,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.25),
      selectedColor: Theme.of(context).colorScheme.secondary,
      hoverColor: Theme.of(
        context,
      ).colorScheme.secondary.withValues(alpha: 0.125),
      onTap: widget.onTap,
    );
  }
}

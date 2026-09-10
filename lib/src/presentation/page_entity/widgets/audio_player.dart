import 'dart:async';

import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Player audio per le interviste in formato mp3 caricate su Supabase Storage.
///
/// L'audio viene caricato in streaming solo al primo play: così aprire il
/// cassetto "Interviste" non scarica nulla finché l'utente non lo chiede.
class InterviewAudioPlayer extends StatefulWidget {
  const InterviewAudioPlayer({
    super.key,
    required this.url,
    this.title,
  });

  final String url;
  final String? title;

  @override
  State<InterviewAudioPlayer> createState() => _InterviewAudioPlayerState();
}

class _InterviewAudioPlayerState extends State<InterviewAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();

  bool _isLoading = false;
  bool _isReady = false;
  bool _hasError = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _ensureLoaded() async {
    if (_isReady || _isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await _player.setUrl(widget.url);
      if (!mounted) return;
      setState(() {
        _isReady = true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggle() async {
    await _ensureLoaded();
    if (!_isReady) return;

    if (_player.playing) {
      await _player.pause();
      return;
    }
    // A fine traccia just_audio lascia la posizione in fondo: riavvolgiamo
    // così il tasto play riparte dall'inizio invece di non fare nulla.
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    // `play()` resta pendente per tutta la durata della riproduzione:
    // volutamente non lo attendiamo per non bloccare il resto della UI.
    unawaited(_player.play());
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    return hours > 0 ? '${hours}:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Grid.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null && widget.title!.trim().isNotEmpty) ...[
            TBody(
              widget.title!,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox.square(dimension: Grid.s),
          ],
          Row(
            children: [
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return GestureDetector(
                    onTap: _hasError ? _retry : _toggle,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _hasError ? Colors.black26 : AppColors.brandColor,
                        shape: BoxShape.circle,
                      ),
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _hasError
                                  ? Icons.refresh
                                  : (playing ? Icons.pause : Icons.play_arrow),
                              color: Colors.white,
                              size: 28,
                            ),
                    ),
                  );
                },
              ),
              const SizedBox.square(dimension: Grid.m),
              Expanded(
                child: _hasError
                    ? const TBody(
                        'Audio non disponibile. Tocca per riprovare.',
                        color: Colors.black54,
                      )
                    : StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          final total = _player.duration ?? Duration.zero;
                          var position = snapshot.data ?? Duration.zero;
                          if (position > total) position = total;
                          final maxMs = total.inMilliseconds.toDouble();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12,
                                  ),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                ),
                                child: Slider(
                                  value: position.inMilliseconds
                                      .toDouble()
                                      .clamp(0, maxMs > 0 ? maxMs : 1),
                                  max: maxMs > 0 ? maxMs : 1,
                                  activeColor: AppColors.brandColor,
                                  inactiveColor: Colors.black12,
                                  onChanged: maxMs > 0
                                      ? (value) => _player.seek(
                                            Duration(
                                              milliseconds: value.round(),
                                            ),
                                          )
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Grid.s,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TBody(
                                      _format(position),
                                      color: Colors.black54,
                                    ),
                                    TBody(
                                      _format(total),
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _retry() async {
    setState(() {
      _hasError = false;
      _isReady = false;
    });
    await _toggle();
  }
}

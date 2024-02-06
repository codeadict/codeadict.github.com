---
tags:
- GNU/Linux cli
- mplayer
- video
type: post
status: publish
title: 'Rotar videos con memcoder y mplayer en linux.'
description: 'Rotar videos con memcoder y mplayer en linux.'
published: true
layout: post
---
A veces nos encontramos con vídeos que se encuentran rotados, como los copiados de una Ipod o reproductor MP4. En Linux existen soluciones para rotarlos.

Si desea rotar su vídeo y guardarlo ya en la posición que desea puede hacerlo con `MENCODER` de la siguiente forma:

Abra una terminal y teclee el siguiente comando:

```bash
mencoder -vf-add rotate=opción \
    -oac mp3lame \
    -ovc lavc /lugar/video_entrada.extensión \
    -o /lugar/video_salida.extensión
```

Donde:

* `-oac` es el codec de salida de audio(Output Audio Codec) pude utilizar otro si Mp3lame no está disponible

* `-ovc` es el codec de salida de vídeo(Output Video Codec)

Si solo desea ver el vídeo rotado sin guardarlo puede usar [Mplayer](http://www.mplayerhq.hu/) mediante el siguiente comando:

```bash
mplayer -vf-add rotate=opción /lugar/video_entrada.extensión
```

**opción:** es la rotación que se le dará al vídeo, se pueden usar las siguientes:

* 0 - Rotar 90 grados en sentido horario y voltear.
* 1 - Rotar 90 grados en sentido horario.
* 2 - Rotar 90 grados a la izquierda.
* 3 - Rotar 90 grados a la izquierda y voltear.

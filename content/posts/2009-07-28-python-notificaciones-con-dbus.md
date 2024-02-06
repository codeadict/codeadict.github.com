---
tags:
- Programming
- Python
type: post
status: publish
title: 'Python: Notificaciones con DBus.'
description: 'Como enviar notificaciones al escritorio Gnome mediante Python y DBus.'
published: true
layout: post
---

Hola gente de la Internet, en este artículo voy a mostrar como enviar notificaciones al escritorio Gnome mediante Python y DBus como se muestra en la imagen siguiente:

![Notificación](/imgs/dbus_notification.png)

```python
#!/usr/bin/env python

import dbus

# Inicializando el bus de tipo session para comunicarse entre aplicaciones
bus = dbus.SessionBus()
# El objeto Notifications se encarga de enviar las notificaciones
noti = bus.get_object("org.freedesktop.Notifications", "/org/freedesktop/Notifications")
interface = dbus.Interface(noti, "org.freedesktop.Notifications")
# Muestro la notificación
# El tercer parámetro es el ícono a mostrar del stock de gtk y el último es el tiempo de la notificación
notificar = interface.Notify(
    "DBus Test", 0, "gtk-about", "Hola mundo", "Hola que viva linux", "", {}, 50000
)
```

¡Espero a alguien le pueda servir!

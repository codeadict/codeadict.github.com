---
tags:
- PHP
- Programming
type: post
status: publish
title: Calcular el trimestre actual en PHP
description: Una pequeña función en PHP que permite calcular el trimestre del año dado el número del mes.
published: true
layout: post
---

Hola amigos, ayer mientras trabajaba me vi en la necesidad de calcular el trimestre del año dado el número del mes y cree esta pequeña función en PHP que permite realizar este cálculo, si no se le pasa ningún mes ella tomará el mes actual por defecto.

Aquí les dejo el código para quien pueda serle útil:

```php
<?php
function trimestre($mes=null){
  $mes = is_null($mes) ? date('m') : $mes;
  $trimestre = floor(($mes-1) / 3) + 1;
  return $trimestre;
}
?>;
```

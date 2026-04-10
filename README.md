# redmine_issue_reminder 🔔

> Plugin para Redmine que envía recordatorios por correo electrónico a los responsables de tickets abiertos — desde el panel de administración, desde el propio ticket, o de forma automática vía cron.

[![Ruby](https://img.shields.io/badge/Ruby-2.7%2B-red?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Redmine](https://img.shields.io/badge/Redmine-5.x-blue?logo=redmine&logoColor=white)](https://www.redmine.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/flitz-svg/redmine_issue_reminder/pulls)

---

## ¿Qué es redmine_issue_reminder?

`redmine_issue_reminder` es un plugin para Redmine que permite notificar por correo a los usuarios que tienen tickets abiertos asignados, recordándoles que deben atenderlos.

| Modo | Descripción |
|------|-------------|
| **Panel admin** | Filtra tickets por proyecto, estado y días sin actualización, y envía recordatorios masivos |
| **Por ticket** | Botón en la vista del ticket para enviar un recordatorio puntual al responsable |
| **Automático (cron)** | Tarea rake programable para envíos diarios sin intervención manual |

---

## Características

- ✅ **Panel de administración** — accesible desde el menú Admin de Redmine
- ✅ **Filtros avanzados** — por proyecto, estado y días de inactividad
- ✅ **Botón por ticket** — visible para admin, autor y responsable del ticket
- ✅ **Agrupación por usuario** — un solo correo por responsable con todos sus tickets
- ✅ **Tarea rake** — integrable con cron o cualquier scheduler
- ✅ **Log detallado** — cada envío queda registrado en la salida estándar

---

## Requisitos

- Redmine **5.x o superior**
- Ruby **2.7+**
- Correo saliente configurado en Redmine (*Administración → Configuración → Correo electrónico*)

---

## Instalación

```bash
# 1. Clona el plugin en la carpeta de plugins de Redmine
cd /path/to/redmine/plugins
git clone https://github.com/flitz-svg/redmine_issue_reminder.git

# 2. Reinicia Redmine
touch /path/to/redmine/tmp/restart.txt
# o según tu servidor:
# sudo systemctl restart redmine
# sudo service apache2 restart
```

---

## Uso

### Panel de administración

En el menú **Administración** aparece la opción **Recordatorios de Tickets**.

1. Selecciona uno o más proyectos (opcional)
2. Selecciona los estados de ticket a incluir (opcional)
3. Indica el mínimo de días sin actualización (opcional)
4. Marca los tickets que quieres incluir
5. Haz clic en **Enviar recordatorios**

### Botón por ticket

Desde la vista de un ticket, el botón **Enviar recordatorio** envía un correo al responsable del ticket. Es visible para:

- Administradores
- El autor del ticket
- El responsable del ticket

### Tarea rake (manual)

```bash
cd /path/to/redmine
bundle exec rake redmine:issue_reminder:send RAILS_ENV=production
```

---

## Automatización con cron

Edita el crontab del usuario que ejecuta Redmine (`redmine`, `www-data`, etc.):

```bash
crontab -e
```

**Ejemplos:**

```cron
# Todos los días a las 08:00
0 8 * * * cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Lunes a viernes a las 09:00
0 9 * * 1-5 cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Dos veces al día: 09:00 y 15:00
0 9,15 * * * cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1
```

> Reemplazar `/path/to/redmine` con la ruta real de tu instalación, por ejemplo `/var/www/redmine` o `/opt/redmine`.

**Si usas rbenv o rvm**, especifica el ejecutable completo:

```cron
# Con rbenv
0 8 * * * cd /path/to/redmine && /home/redmine/.rbenv/shims/bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Con rvm
0 8 * * * cd /path/to/redmine && /usr/local/rvm/bin/rvm default do bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1
```

**Verificar el log:**

```bash
tail -f /var/log/redmine_reminder.log
```

---

## Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Haz fork del repositorio
2. Crea una rama: `git checkout -b feature/mi-mejora`
3. Haz commit de tus cambios: `git commit -m 'feat: descripción clara'`
4. Abre un Pull Request describiendo el problema que resuelve

Para bugs, abre un [issue](https://github.com/flitz-svg/redmine_issue_reminder/issues) con:
- Versión de Redmine y Ruby (`bundle exec ruby -v`)
- Sistema operativo y versión
- Pasos exactos para reproducir el error
- Mensaje de error completo

---

## Licencia

MIT License

Copyright (c) 2026 Maurizio Fiamene

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

<p align="center">
  Hecho con ❤️ para la comunidad Redmine · <a href="https://github.com/flitz-svg/redmine_issue_reminder/issues">Reportar un bug</a> · <a href="https://github.com/flitz-svg/redmine_issue_reminder/issues">Solicitar una función</a>
</p>

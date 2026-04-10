# Redmine Issue Reminder

Plugin para Redmine que permite enviar recordatorios por correo electrónico a los usuarios con tickets abiertos asignados.

## Funcionalidades

- Panel de administración para filtrar tickets por proyecto, estado y días sin actualización
- Envío masivo de recordatorios desde el panel admin
- Botón de recordatorio individual desde la vista de un ticket (visible para admin, autor o responsable)
- Tarea rake para envíos automáticos programados

## Instalación

1. Clonar o copiar la carpeta en `plugins/redmine_issue_reminder` dentro de tu instalación de Redmine:

```bash
cd /path/to/redmine/plugins
git clone https://github.com/flitz-svg/redmine_issue_reminder.git
```

2. Reiniciar Redmine.

## Uso

### Panel de administración

En el menú **Administración** aparece la opción **Recordatorios de Tickets**.  
Desde ahí se pueden filtrar tickets y enviar recordatorios a los responsables.

### Tarea rake

```bash
bundle exec rake redmine:issue_reminder:send RAILS_ENV=production
```

### Automatización con cron

Editar el crontab del usuario que ejecuta Redmine (normalmente `redmine` o `www-data`):

```bash
crontab -e
```

**Ejemplos de configuración:**

```cron
# Todos los días a las 08:00
0 8 * * * cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Lunes a viernes a las 09:00
0 9 * * 1-5 cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Dos veces al día: 09:00 y 15:00
0 9,15 * * * cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1
```

> Reemplazar `/path/to/redmine` con la ruta real de la instalación, por ejemplo `/var/www/redmine` o `/opt/redmine`.

**Si se usa rbenv o rvm**, hay que especificar el ejecutable completo de rake:

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

## Requisitos

- Redmine 5.x o superior
- Ruby 2.7+
- Correo saliente configurado en Redmine

## Licencia

MIT

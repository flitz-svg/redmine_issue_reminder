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
bundle exec rake redmine:send_reminders RAILS_ENV=production
```

Se puede programar con cron para ejecuciones automáticas.

## Requisitos

- Redmine 5.x o superior
- Ruby 2.7+
- Correo saliente configurado en Redmine

## Licencia

MIT

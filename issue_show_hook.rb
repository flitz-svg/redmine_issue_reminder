class IssueReminderShowHook < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context = {})
    issue = context[:issue]
    return '' unless issue&.assigned_to.is_a?(User) && issue.assigned_to.active?

    send_url     = "/issues/#{issue.id}/reminder/send"
    btn_label    = l(:ir_btn_send_single).to_json
    confirm_msg  = l(:ir_js_confirm_single,
                     name:  issue.assigned_to.name,
                     email: issue.assigned_to.mail).to_json

    <<~HTML
      <form id="ir-hidden-form"
            action="#{send_url}"
            method="post"
            style="display:none;">
        <input type="hidden" name="authenticity_token" id="ir-csrf-token" value="">
      </form>

      <script>
      (function() {
        function init() {
          var meta = document.querySelector('meta[name="csrf-token"]');
          if (meta) {
            var t = document.getElementById('ir-csrf-token');
            if (t) t.value = meta.getAttribute('content');
          }

          var link = document.createElement('a');
          link.className = 'icon icon-email';
          link.href = '#';
          link.textContent = #{btn_label};
          link.style.marginRight = '4px';
          link.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm(#{confirm_msg})) {
              document.getElementById('ir-hidden-form').submit();
            }
          });

          var allContextuals = document.querySelectorAll('div.contextual');
          var targetBar = null;
          for (var i = 0; i < allContextuals.length; i++) {
            if (allContextuals[i].querySelector('a[href*="/edit"], a[href*="copy"]') ||
                allContextuals[i].querySelector('.next-prev-links') ||
                allContextuals[i].textContent.indexOf('Modificar') !== -1 ||
                allContextuals[i].textContent.indexOf('Edit') !== -1) {
              targetBar = allContextuals[i];
              break;
            }
          }

          if (!targetBar && allContextuals.length > 0) {
            targetBar = allContextuals[0];
          }

          if (targetBar) {
            targetBar.insertBefore(link, targetBar.firstChild);
          }
        }

        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', init);
        } else {
          init();
        }
      })();
      </script>
    HTML
  end
end

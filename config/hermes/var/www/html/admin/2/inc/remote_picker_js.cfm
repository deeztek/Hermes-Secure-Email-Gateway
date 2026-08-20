<!---
Hermes Secure Email Gateway - Shared remote picker

Turns a <select class="remote-picker"> into a TomSelect that fetches its
options from a Hermes JSON endpoint, and optionally fills read-only detail
fields from the chosen row.

WHY THIS EXISTS
Every picker it replaces was a plain <input type="text"> with a jQuery UI
autocomplete bound on keydown. That had three problems reported by users
(GitHub #310): the field looked like an ordinary text box with no chevron or
any other cue that a list existed, clicking it did nothing at all, and the
widget was not even constructed until the first keystroke, so that keystroke
was consumed building it rather than searching.

Each page also carried its own copy of the same forty lines, which is how the
four copies had already drifted apart.

USAGE

  <select class="remote-picker form-control"
          id="certificate_1"
          data-endpoint="./inc/getcertificates.cfm"
          data-target-id="certificateno_1"
          data-target-subject="subject_1">
    <option value="7" selected>Current cert</option>
  </select>

  <cfinclude template="./inc/remote_picker_js.cfm">

ATTRIBUTES

  data-endpoint      Required. A Hermes endpoint answering the established
                     two-request contract: `request=1` with `search` returns
                     [{value, label}] for the list, `request=2` with `id`
                     returns [{...detail...}] for one row.

  data-value-field   Which key of the list row becomes the submitted value.
                     Defaults to `value`, the row id. Set to `label` where the
                     server reads the visible string instead of an id, which is
                     the case for the timezone picker: `edit_system_settings.cfm`
                     validates `form.timezone` against the `timezones` table,
                     whereas the certificate pages read a hidden id field and
                     ignore the visible one entirely. Getting this wrong submits
                     an id where a name is expected, so it is explicit rather
                     than inferred.

  data-target-KEY    Optional, repeatable. Puts `response[0][KEY]` from the
                     `request=2` reply into the element whose id is the
                     attribute's value. `data-target-serial="serial_1"` means
                     "write the row's `serial` into `#serial_1`". Absent
                     attributes are simply not written, which is how the Dovecot
                     picker skips the certificate type field it does not have.
                     With no data-target-* attributes at all the second request
                     is not issued.

NOTES

  - The initial selection is rendered server-side as a plain <option selected>.
    TomSelect does not fire onChange while adopting an existing selection, so
    the server-rendered detail fields are left alone on load rather than being
    refetched and rewritten.
  - Endpoint keys are read case-insensitively. These endpoints build their
    structs with bracket notation so the case survives today, but Lucee
    uppercases struct keys on serialization by default and one refactor there
    would otherwise empty every picker on the console.
--->

<script>
(function () {

  // Collect every data-target-KEY attribute into {key, id} pairs.
  function detailTargets(el) {
    var out = [];
    Array.prototype.forEach.call(el.attributes, function (attr) {
      if (attr.name.indexOf('data-target-') === 0) {
        out.push({ key: attr.name.slice('data-target-'.length), id: attr.value });
      }
    });
    return out;
  }

  // Lucee may hand back either case. Try as written, then uppercase.
  function pick(row, key) {
    if (row == null) { return undefined; }
    if (row[key] !== undefined) { return row[key]; }
    return row[key.toUpperCase()];
  }

  function initRemotePickers() {
    if (typeof TomSelect === 'undefined' || typeof jQuery === 'undefined') { return; }

    Array.prototype.forEach.call(
      document.querySelectorAll('select.remote-picker'),
      function (el) {
        if (el.tomselect) { return; }

        var endpoint = el.getAttribute('data-endpoint');
        if (!endpoint) { return; }

        var valueField = el.getAttribute('data-value-field') || 'value';
        var targets    = detailTargets(el);

        new TomSelect(el, {
          valueField: valueField,
          labelField: 'label',
          searchField: 'label',
          maxItems: 1,
          create: false,
          // Fetch as soon as the field is focused, not only once something has
          // been typed. This is the whole point of the rewrite: clicking must
          // show the list.
          preload: 'focus',
          placeholder: el.getAttribute('placeholder') || 'Click to choose, or type to search...',

          load: function (query, callback) {
            jQuery.ajax({
              url: endpoint,
              type: 'post',
              dataType: 'json',
              data: { search: query, request: 1 },
              success: function (data) {
                callback((data || []).map(function (row) {
                  return { value: pick(row, 'value'), label: pick(row, 'label') };
                }).filter(function (o) {
                  return o.value !== undefined && o.label !== undefined;
                }));
              },
              error: function () { callback(); }
            });
          },

          onChange: function (chosen) {
            if (!targets.length || !chosen) { return; }
            jQuery.ajax({
              url: endpoint,
              type: 'post',
              dataType: 'json',
              data: { id: chosen, request: 2 },
              success: function (resp) {
                if (!resp || !resp.length) { return; }
                targets.forEach(function (t) {
                  var node  = document.getElementById(t.id);
                  var value = pick(resp[0], t.key);
                  if (node && value !== undefined) { node.value = value; }
                });
              }
            });
          }
        });
      }
    );
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initRemotePickers);
  } else {
    initRemotePickers();
  }

})();
</script>

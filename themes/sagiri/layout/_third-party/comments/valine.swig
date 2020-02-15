{% if page.comments and theme.valine.enable and theme.valine.appid and theme.valine.appkey %}

  <script type="text/javascript">
    new Valine({
        el: '#comments' ,
        verify: {{ theme.valine.verify }},
        notify: {{ theme.valine.notify }},
        app_id: '{{ theme.valine.appid }}',
        app_key: '{{ theme.valine.appkey }}',
        placeholder: '{{ theme.valine.placeholder }}',
		highlight: true,
		path: window.location.pathname 
    });
  </script>
{% endif %}

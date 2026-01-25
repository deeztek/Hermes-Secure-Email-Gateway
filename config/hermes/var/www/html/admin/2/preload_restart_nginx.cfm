<!-- Overlay Spinner -->
<div id="loadingOverlay" style="position:fixed; left:0; top:0; width:100%; height:100%; background:white; z-index:9999; display:flex; align-items:center; justify-content:center;">
  <div class="preloader flex-column justify-content-center align-items-center" style="width: 4rem; height: 4rem;" role="status">
   <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
   
  </div>
</div>



<script>
  async function postToRestartNginx() {
    try {
      await fetch('./inc/restart_nginx_post.cfm?restart=1', {
        method: 'POST'
      });
    } catch (err) {
      console.error('Error posting to restart nginx:', err);
    }
  }

  function checkServerReadyAndRedirect() {
    fetch('/index.cfm')
      .then(response => {
        if (response.ok) {
          if (document.referrer) {
            window.location.href = document.referrer;
          } else {
            window.location.href = '/';
          }
        } else {
          setTimeout(checkServerReadyAndRedirect, 1000); // retry in 1s if not OK
        }
      })
      .catch(() => {
        setTimeout(checkServerReadyAndRedirect, 1000); // retry in 1s on fetch error
      });
  }

  window.onload = async function() {
    await postToRestartNginx();
    setTimeout(checkServerReadyAndRedirect, 30000); // wait 30s, then begin health checks every 1s
  };
</script>


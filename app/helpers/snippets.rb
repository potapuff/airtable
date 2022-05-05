module Sinatra
  module SnippetHelpers

  def ga_snippet
    return unless (id = MoocApi.settings.google_analytics)
    <<-TEXT
    <script async src="https://www.googletagmanager.com/gtag/js?id=#{id}"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '#{id}');
    </script>
    TEXT
  end

  def rollbar_snippet
    return unless (id = MoocApi.settings.rollbar['client_token'])
    <<-TEXT
    <script>
    var _rollbarConfig = {
      accessToken: "#{id}",
      captureUncaught: true,
      captureUnhandledRejections: true,
      payload: {
        environment: "#{MoocApi.settings.environment}"
      }
    };
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/rollbar.js/2.25.0/rollbar.min.js" integrity="sha512-//M10QI7wc00lic9Oxbfn2KSzlmaa8l7UzzTqR2GtWVwxHIGpKnGwAcgtcAqQGBR2uWoSXD2hmPfuumITQMYlg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    TEXT
  end

  end

  helpers SnippetHelpers
end
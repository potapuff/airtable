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
    <script src="https://cdn.rollbar.com/rollbarjs/refs/tags/v2.26.2/rollbar.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    TEXT
  end

  end

  helpers SnippetHelpers
end
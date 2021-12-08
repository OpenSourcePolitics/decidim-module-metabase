# Decidim::Metabase

Display your Metabase dashboards directly in Decidim's administration area.

## Description

This module implements Metabase dashboard iframes in administration panel.  

## Getting started

In order to implement this module in your Decidim application, you needs to have a `v0.25` Decidim instance. 

1. Add this line to your application's Gemfile:

```ruby
gem "decidim-metabase", git: "https://github.com/OpenSourcePolitics/decidim-module-metabase.git"
```

2. Install gem

```bash
bundle
```

3. Configure Metabase secrets in your Decidim app

In file `config/secrets.yml`:
```yaml
  metabase:
    enabled: true
    site_url: https://your.metabase.instance.com
    secret_key: your_secret_key
    dashboard_ids:
      - ID_to_int
```

`dashboard_ids` key must be an Array.

## Contributing

Contributing to Decidim - See [Decidim](https://github.com/decidim/decidim).
Contributing to Decidim Metabase module - See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the [GNU AFFERO GENERAL PUBLIC LICENSE](./LICENSE-AGPLv3.txt). 

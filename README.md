gemstat enable you to know "Frequently Bought(Required) Together" thing or "Customers Who Bought(Required) This Item Also Bought(Required)" thing.

# Usage

```
# Install
$ gem install gemstat

# Show a list of gems which are similar to a given gem
$ gemstat look_like ../sinatra/Gemfile
aldebaran                     (0.5pt)
annyong                       (0.333pt)
aframe-switch                 (0.333pt)
acceptable                    (0.333pt)
angularjs_json_middleware     (0.333pt)
adsf                          (0.333pt)
anupom-anobik                 (0.333pt)
any_view                      (0.333pt)
arthurgeek-nyane              (0.333pt)
aslakhellesoy-bcat            (0.333pt)

# Show a list of gems which are suggested for a given gem
$ gemstat suggest_for activerecord
rspec                         (0.667pt)
activerecord                  (0.667pt)
tzinfo                        (0.333pt)

# Show a list of gems a given gem is required by
$ gemstat also_required actionview
aaf-lipstick
action_widget
actionmailer
actionpack
actionview-helpers-auto_tag_helper
actionview-pathfinder
actionview-rev_manifest
activerecord-userstamp
augit
aws_upload

# Show a list of gems a given gem dependents on
$ gemstat dependency actionview
activesupport
builder
erubis
rails-html-sanitizer
rails-dom-testing
actionpack
activemodel
```

### license

MIT

### TODO

- Modify `update` subcommand to allow incremental update
- Speed up by changing data cache strategy(migrate data stored in more than 100k files to single data file) and use C or mruby implementation for calculation part
- Update README.md and gemstat.gemspec with better descriptions
- Windows support (Now only Mac and Linux is supported)

# Points Application

This is a Rails application to collaboratively estimate stories

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ ./bin/setup
```

## Environment Variables
```
ORGANIZATION_LOGIN=<INSERT-HERE>
GITHUB_APP_ID=<INSERT-HERE>
GITHUB_APP_SECRET=<INSERT-HERE>
```
GITHUB_APP_ID and GITHUB_APP_SECRET: You need to sign up for an OAuth2 Application ID and Secret on the [GitHub Applications Page](https://github.com/settings/applications).

ORGANIZATION_LOGIN: This is the organization name as it appears in the Github URL, for instance “orgname’ in https://github.com/orgname. It is needed to check if users are a part of the organization.


## Starting the Server
```
$ rails s
```
Go to http://localhost:3000

## Running Tests
```
$ rails spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/points](https://github.com/fastruby/points). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

 Everyone interacting in the Points project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fastruby/points/CODE_OF_CONDUCT.md).

## Sponsorship

![FastRuby.io | Rails Upgrade Services](https://github.com/fastruby/points/raw/master/app/assets/images/fastruby-logo.png)


`Points` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.

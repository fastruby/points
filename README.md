# Points

[![Points](https://github.com/fastruby/points/actions/workflows/tests.yml/badge.svg)](https://github.com/fastruby/points/actions/workflows/tests.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/2484911d9c021cfee1ce/maintainability)](https://codeclimate.com/github/fastruby/points/maintainability)

This is a Rails application to collaboratively estimate stories.

## Getting started

To get started with the app, clone the repo and then install the needed gems running the setup script:

```
$ ./bin/setup
```

## Environment Variables

`ORGANIZATION_LOGIN`: This is the organization name as it appears in the GitHub URL, for instance `orgname` in https://github.com/orgname. It is needed to check if users are a part of the organization. Ensure that your membership is set to _public_ when you visit https://github.com/orgs/orgname/people.

If you don't belong to any organization, you can set up one here: https://github.com/organizations/plan

Make sure you add your organization to the `.env` file like this:

```
ORGANIZATION_LOGIN=orgname
```

`GITHUB_APP_ID` and `GITHUB_APP_SECRET`: These are the credentials of the OAuth GitHub App that you need to create. Follow the instructions on this link to create one: [Creating an OAuth GitHub App](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)

When creating the OAuth GitHub App, the `Homepage URL` field should be set to http://localhost:3000, and the `Authorization callback URL` should be http://localhost:3000/users/auth/github/callback.

Once you create the app and generate credentials for it, make sure you add them to the `.env` file like this:

```
GITHUB_APP_ID=xxxxxxxxxxxxxxxxxxxx
GITHUB_APP_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Starting the Server

```
$ rails s
```

Go to http://localhost:3000

## Running Tests

```
$ rails spec
```

## Using Docker

> NOTE: You'll need to have docker and docker-compose installed

Build the points docker image

```bash
./bin/setup_with_docker
```

Run the app

```
./bin/start_with_docker

or

docker-compose up web-next
```

## Admin Users

Users are created without admin privileges by default, because admin users have access to a few more features related to reports and setting real score of stories.

Currently, the only way to flag a user as `admin` is a direct database update using either postgres cli or the rails console.

If you want to set the flag for a user, you can follow these steps:

```bash
rails console

or

docker-compose run --rm web rails console
```

and then:

```ruby
User.find_by(email: "user@example.com").update_attribute(:admin, true)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/points](https://github.com/fastruby/points). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

When Submitting a Pull Request:

- If your PR closes any open GitHub issues, please include `Closes #XXXX` in your comment

- Please include a summary of the change and which issue is fixed or which feature is introduced.

- If changes to the behavior are made, clearly describe what changes.

- If changes to the UI are made, please include screenshots of the before and after.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Points project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fastruby/points/CODE_OF_CONDUCT.md).

## Sponsorship

![FastRuby.io | Rails Upgrade Services](https://github.com/fastruby/points/raw/main/app/assets/images/fastruby-logo.png)

`Points` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.

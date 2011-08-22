# My Node Deployment Scripts
This project shares the capistrano scripts I normally use for my 
node.js based applications, stolen shamelessly from [Nuclear Rooster](http://dev.nuclearrooster.com/2010/07/18/capistrano-scripts-for-node-js/) with some adaptions. It uses upstart on the serverside to run
node as a daemon and respawns on server crash.

I use this script on three production sites and it has worked like a 
charm over the past year. Customize it to fit your needs.

## Using it
You'll need ruby, gem, capistrano, and capistrano-gem installedto deploy form your local workstation. I recommend rvm but any installation will do. Simply install capistrano via gems:

    gem install capistrano
    gem install capistrano-ext

On the server side you'll need to have whatever commands that are referenced in the config/deploy.rb file installed. In the default script you'll need at least the following:
     *  upstart
     *  node
     *  npm

You'll also need to have your ssh public key installed on the server for automated deployments. Follow the instructions found at [insert url here] for details. You'll also need an ssh-agent running (this is enabled by default on *nix based systems already running XWindows. OS X also has this by default. Windows doesn't because it sucks like that. If you're deploying from a linux server then see this post on how to set your system up.


## Deploying
First you'll need to configure your target environment. Run `cap deploy:setup` to setup the serverside directory structures used for deployment. Then to deploy either type
     *  cap deploy 
     *  cap deploy staging
     *  cap deploy production


Feel free to fork and improve, I'll accept any useful pull requests.

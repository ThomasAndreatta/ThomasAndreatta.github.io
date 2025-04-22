---
title:   "Macedonia: The infrastructure"
classes: wide
header:
  teaser: /img/postcover/earth.png
ribbon: green
categories:
  - Projects
toc: true
toc_label: "Macedonia is my personal infrastructure hosting all my services."
---

# Backstory

When working my first job at some point I've been tasked with the setup of an
internal system to host our team instance of `redmine`, which if you don't know,
is a task manager built to be similar to github with projects and issues. Got
assigned an internal linux server, started thinkering with docker and little do
you know couple weeks after I had came up with **Macedonia** an entire
infrastructure entirely conteinerized, isolated if not for a reverse proxy, and
able to spawn and attach conteinerized services on the fly without interruption.

After leaving the company I started missing my issue tracker right away and only
recently had the time and will to rebuild it from scratch, but better. The
original was a bit too clogged and fragile relying on ad hoc scripts and not
very "portable", the new version of Macedonia is completly detached from
everything, it can just be pulled from git, set the `.env` file and with a
simple `docker compose up -d` the infrastructure will be up and running (if a
database backup is present its possible to restore it too).

# Macedonia: My Docker-Powered Infrastructure

So what exactly is Macedonia? It's basically my personal infrastructure solution
that brings together project management, monitoring, and some custom
applications I've built - all working together without the usual headaches of
configuration.

All this is currently hosted on a `raspberry-pi 4` in my laundry room so if you
feel like running your own Macedonia you for sure have the hardware to do it.

## How It All Started

When I first built Macedonia at that job, I was just trying to solve a simple
problem - get Redmine working for the team. But ya know how things go, "We
could use this", "Adding this would be cool", "We could write a script for that"
and one thing pulls the other and a lot of cool idea and things I could 
implement came up.

Couple things I was sure about:
1. I wanted everything self-contained - no services fighting with each other
2. It needed to be easy to backup and update - nobody (**I**) wants to spend the
   weekend fixing broken services
3. I wanted to add new stuff without breaking everything else
4. And of course, it needed to be secure enough that my IT folks wouldn't freak
   out (... I guess me included, #ICTSecurity you know...)

The solution? Docker compose became my best friend. Let me show you how I put it
all together for my personal version.

> Yes, I know that kubernetes-like services are more versatile for this type of
> things, but I didn't back then... and it started off as a small thing anyway! 

## How Macedonia Works

The way I've set up Macedonia is pretty straightforward. Each service has its
own space to do its thing, but they can all talk to each other when they need
to. It's like having roommates who each have their own room but share the
kitchen and living room (which can still be very problematic).

### The Main Pieces

![Macedonia
Infrastructure png gonna do it at some point](https://via.placeholder.com/800x400.png?text=Macedonia+Infrastructure+Diagram)

#### Redmine: Where I Track Everything

The star of the show is definitely Redmine - it's what started this whole
journey. I use it to track all my projects and tasks. My setup is pretty neat:

- It runs on its own URL path (`/redmine`), so it doesn't hog the whole server
- I've added some custom themes and plugins to make it less... ugly
- All the data sits in PostgreSQL, which keeps everything nice and reliable

#### PostgreSQL: One Database to Rule Them All

I learned pretty quickly that having separate databases for every service is a
pain to manage. So in Macedonia, everything lives in one PostgreSQL instance:

- Different databases for each service (Redmine, Grafana etc) but all in one
  place
- I wrote some scripts that set everything up automatically when you first start
- The database security is handled through `pg_hba.conf` which sounds fancy but
  just controls who can connect

#### Nginx: The Traffic Cop

Nginx is like the bouncer at the club - it decides who goes where:

- All traffic comes through here first
- It handles all the SSL stuff so the other containers don't have to worry about
  it
- Handles the S in https cause my infrastructure is accessible to the internet
  to allow me to use it wherever and I don't like the browser screaming at me.

#### Grafana: Pretty Graphs for Everything

I'm a sucker for data visualization, so Grafana was a must-have:

- It uses the same PostgreSQL as everything else
- I've set up custom dashboards to keep an eye on all my stuff
- It plays nicely with the rest of the system

#### Webclock: Friend Shoutout

One of the coolest things about this setup is how easy it is to add random stuff.
I wanted to make a friend have a laugh and showcase how easy and quick it is to
add services so I stole a friend webclock and just attached it to Macedonia

- It sits right alongside the "professional" tools without any special treatment
- Uses the same network and security setup as everything else
- It's a cool clock and I'm using it as excuses to buy a vertical (3rd) monitor

### How Everything Talks to Each Other

The containers talk to each other using their names in a Docker bridge network,
which means:

- They can find each other without needing fixed IP addresses
- They're isolated from the rest of my network
- I can change how the network works without breaking everything

## How It's Organized: A Place for Everything

I'm kind of obsessed with keeping things organized, so Macedonia has a clean
structure:

```
infrastructure/
└── container/
    ├── backup/         # Where all the backups live
    ├── grafana/        # My monitoring dashboards
    ├── nginx/          # The front-end stuff
    ├── postgres/       # Database central
    ├── redmine/        # Project tracker
    └── webclock/       # My custom app
    └── etc...
```

Each service has its own folders for:
- Config files
- Data that needs to persist
- Any customizations I've made

This way, when something breaks (and let's be honest, it always does
eventually), I know exactly where to look.

## The Secret Sauce: Just One Config File

All the passwords and sensitive stuff live in a single `.env` file:

- Database usernames and passwords
- What to name each container
- Network settings
- Email setup for notifications

Which will be used by the `dockercompose.yaml` file to load in every container
only the required variables.

This way, I can share the code without sharing my passwords. Plus, when I want
to set it up somewhere new, I just need to change this one file.

## Backups: Because Stuff Happens

I've been burned enough times to know backups are crucial. Macedonia has a
pretty solid backup system:

- The database gets dumped regularly with a cronjob using `pg_dump`
- You can back up just one service or the whole thing
- Restoring from a backup is super simple

All the backups go in their own directory, so I can easily copy them somewhere
else for safekeeping. I have a simple `.sh` script that allows you to backup
and restore for a single service or the entire infrastructure.

## Setting It Up: Easier Than You'd Think

Getting this whole thing running is actually pretty straightforward:

1. Clone the repository to your server
2. Set up your `.env` file with your own settings
3. Maybe tweak `pg_hba.conf` if you're changing the network
4. Run `docker-compose up -d`

That's it! A few minutes later, you've got this whole infrastructure up and
running. It's pretty satisfying to see everything come online at once.

## Why I Bother With All This

So why did I rebuild Macedonia after leaving that job? It's not just about
having a task tracker. For me, it's about:

- **Keeping it simple**: Everything just works together without constant
  tweaking
- **Making maintenance easy**: One command to start, stop, or update everything
- **Having good security**: Everything stays in its own lane
- **Owning my stuff**: I control my data and my services

Whether you're a tinkerer like me or just someone who wants their digital life
organized, having your own infrastructure is pretty satisfying.

# What's next?

I'm planning to move everything to a kubernetes system, I have other containers
running on the raspberry and I'd like to do some load distribution adding an
additional machine (old laptop) and I fear docker is not really optimized for
that. 
On top of that those services serves another purpose and I'd like to detach
them from the same public domain somehow, probably gonna have to add an
additional reverse proxy that handles the requests on a high level and then
redirects them to either Macedonia or the rest of the infrastructure... sounds
painful tho.

# README
Test task

Ruby  2.4.1, Rails 5.1.3
### System dependencies
* postgressql 9.4 or higher

### Configuration

Clone this repo, run bundle.
Rename `database.yml.example` to `database.yml` and set his variables.
Create `secret.yml`

### Database creation
```
run rake db:setup
```
For parallel testing create test_env databases
Create additional database(s)
```
rake parallel:create
```
Copy development schema (repeat after migrations)
```
rake parallel:prepare
```
Setup environment from scratch (create db and loads schema, useful for CI)
```
rake parallel:setup
```
### Database initialization

You can add users`s seed data 

```
rake db:seed:users_seed
```

### Test

```
rspec spec/ 
```
For parallel testing run
```
rake parallel:spec
```

The acceptance tests used capybara webkit, You must have to install his dependencies

### Requirements

1. User can have two roles: project manager and collaborator.
2. PM can create a team and invite a collaborator. Collaborator is a part of team only after approving of invitation.
3. PM can create the tasks and assign them to collaborators.
4. PM can delete and edit tasks.
5. Task has states: new(not assigned), open(assigned), in progress, done.
6. Task has types: bug fix, code, test.
7. When task is created it has a status 'new'. When task is assigned it changes status to 'open'.
8. PM can see all tasks of all collaborators. PM can't change task status.
9. Collaborator can see all his tasks.
10. Collaborator can change task status, but can only set 'in progress', 'done'.


### Important notes

The requirement #1 does not exactly state that manager and collaborator roles are exclusive. Given that ambiguity a number of architectural decisions has been made:

1. All users can be a collaborator or project manager depending on context;
2. In order to become a project manager, a user can create a team and become its owner;
3. A user can own multiple teams;
4. In order to get collaborators, a team owner should invite other potential collaborator users;
5. A potential collaborator can either accept or reject an invitation to a team.

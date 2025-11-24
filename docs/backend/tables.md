# Tables Overview

This document outlines the core database models for the system, including their fields, purposes, and relationships.

**Note**: Fields marked with **(?)** are **nullable**.

## User

Represents an individual who can create events, join events, and upload photos.

- **ID**
- **email**
- **name**
- **created at**
- **updated at**

## Event

Represents an event that users can create and collaborate on. Each event can have many photos and many associated users with varying access levels.

- **ID**
- **title**
- **description (?)**
- **date**
- **creator ID** — references the _User_ who created the event
- **invitation URL (?)** — shareable link for inviting users
- **created at**
- **updated at**

## Event Access

Represents the many-to-many relationship between Users and Events, while also storing each user’s access level for that event.

- **ID**
- **user ID** — references the _User_ who is part of the event
- **event ID** — references the _Event_ the user is associated with
- **access level** — integer representing the user’s permissions (0: admin, 1: contributor, 2: viewer)
- **created at**
- **updated at**

## Photo

Represents an image uploaded to an event.

- **ID**
- **image URL**
- **added by** — references the _User_ who uploaded the photo
- **event ID** — references the _Event_ the photo belongs to
- **created at**
- **updated at**

## Auth

Stores authentication credentials for registered users.

- **ID**
- **user ID** — references the _User_ the auth record belongs to
- **password hash**
- **refresh token**
- **created at**
- **updated at**

## Relationships

- **User ↔ Auth** - one-to-one

- **User ↔ Event** — many-to-many  
  Implemented through a join table (e.g., _EventAccess_) that stores each user’s access level for an event.

- **Event → Photo** — one-to-many

# Tables Overview

This document outlines the core database models for the system, including their fields, purposes, and relationships. 

**Note**: Fields marked with **(?)** are **nullable**.

## User

Represents an individual who can create events, join events, and upload photos.

- **ID**
- **email**
- **name**
- **username (?)** — optional profile username
- **password (temporary, plain text) (?)** — *currently stored for prototyping under time pressure; will be removed and replaced with a secure password-management system*
- **created at**
- **updated at**

**Note:** Password storage will be redesigned using a dedicated authentication layer or a hashed credential table.

## Event

Represents an event that users can create and collaborate on. Each event can have many photos and many associated users with varying access levels.

- **ID**
- **title**
- **description (?)**
- **date**
- **creator ID** — references the *User* who created the event.
- **invitation URL (?)** — shareable link for inviting users.
- **created at**
- **updated at**


## Event Access

Represents the many-to-many relationship between Users and Events, while also storing each user’s access level for that event.

- **ID**
- **user ID** — references the *User* who is part of the event.
- **event ID** — references the *Event* the user is associated with.
- **access level** — integer representing the user’s permissions (0: admin, 1: contributor, 2: viewer)
- created at
- updated at


## Photo

Represents an image uploaded to an event.

- **ID**
- **image URL**
- **description (?)**
- **added by** — references the *User* who uploaded the photo.
- **event ID** — references the *Event* the photo belongs to.
- **created at**
- **updated at**

## Relationships

- **User ↔ Event** — many-to-many  
  Implemented through a join table (e.g., *EventAccess*) that stores each user’s access level for an event.

- **Event → Photo** — one-to-many

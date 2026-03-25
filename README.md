# 🏃‍♂️ RunHub: Race Registration Platform

![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-626CD9?style=for-the-badge&logo=Stripe&logoColor=white)

## 📖 Project Overview
RunHub is a full-stack, two-sided marketplace that connects **Race Organizers** with **Runners**. It provides a seamless platform for event companies to create, manage, and promote races, while allowing runners to discover local events, register, and process entry fee payments securely.

This project was built to demonstrate advanced full-stack capabilities, including:
*   Building a stateless, RESTful API using **Ruby on Rails 7**.
*   Implementing custom **JWT (JSON Web Token)** authentication from scratch.
*   Designing a complex relational database schema in **PostgreSQL** to handle strict user roles.
*   Consuming the API with a modern, fast **React.js (Vite)** frontend.
*   Integrating third-party payment processing via **Stripe**.

---

## ✨ Features

### 🏢 For Organizers (Business/Enterprise)
*   **Dedicated Profiles:** Manage enterprise details (Company Name, Website, Description).
*   **Race Management:** Create upcoming races with specific details (Date, Location, Distance, Capacity, Price).
*   **Participant Tracking:** View a dashboard of registered runners for specific events to manage capacity.

### 👟 For Runners (Individuals)
*   **Race Discovery:** Browse a feed of upcoming races.
*   **Registration & Checkout:** Book a spot in a race and securely pay the entry fee via Stripe.
*   **Runner Dashboard:** Track upcoming and past races in a personalized dashboard.

---

## 🛠 Tech Stack & Architecture

### Frontend (Client)
*   **Framework:** React.js (Bootstrapped with Vite for optimized builds).
*   **Routing:** React Router.
*   **State Management:** (TBD - e.g., Redux or React Context).

### Backend (API)
*   **Framework:** Ruby on Rails 7 (API-only mode).
*   **Authentication:** Custom JWT stateless authentication using `jwt` and `bcrypt` (No Devise).
*   **Database:** PostgreSQL.
*   **Payments:** Stripe API.

## 🚀 Local Setup & Installation

*(Note: This section will be updated as the frontend is initialized)*

### Prerequisites
*   Ruby 3.x+
*   Node.js & npm/yarn
*   PostgreSQL

### Backend Setup
1. Clone the repository: `git clone <your-repo-url>`
2. Navigate to the API directory: `cd run_hub_api`
3. Create local environment variables: `cp .env.example .env`
4. Install Ruby gems: `bundle install`
5. Setup the database: `rails db:create db:migrate db:seed`
6. Start the Rails server: `rails s` (Runs on `http://localhost:3000`)

---

## 🗺️ Roadmap & Future Features
*   [ ] Integrate Stripe Webhooks for asynchronous payment status updates.
*   [ ] Add an `Admin` role for platform-wide moderation.
*   [ ] Implement email notifications for successful race registrations.
*   [ ] Add filtering and search capabilities for the Runner race feed.

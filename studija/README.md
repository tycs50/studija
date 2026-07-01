# STUDIJA
#### Video Demo: https://youtu.be/RfV5J5pzzXE
#### Description:

Studija is a native, performance-driven iOS application designed to help students, academics, and lifelong learners effortlessly organize their educational workflows. Built entirely with SwiftUI, Studija serves as a central hub for managing complex multi-week schedules, tracking academic assignments, and customizing course aesthetics.
The application is built with an offline-first philosophy, ensuring that all user data is safely persisted directly on the device using Apple's robust Core Data framework. With native, dynamic support for both Light and Dark appearances, Studija seamlessly adapts to the system environment, providing an eye-friendly, distraction-free user experience around the clock.

# Key Features At A Glance
- Dynamic Data Persistence: Full offline functionality powered by local Core Data storage with secure background contexts.
- Adaptive Theme Support: Automatic, fluid transitions between Light and Dark modes utilizing system semantic color hierarchies.
- Multi-Schedule Architecture: Ability to create, store, and switch between separate independent schedules (e.g., different semesters or terms).
- Granular Task Tracking: A dedicated task manager linked directly to academic subjects with priority filtering.
-  Rich Visual Customization: Extensive CRUD operations for custom class types, icons, and color-coded themes.

# Detailed Component Breakdown
## 1. Home Dashboard (The Core Experience)
- The Home Tab functions as the intelligent command center of the application. It dynamically aggregates all immediate, high-priority data points relevant to the current day.
- Smart Date Navigation: Users can traverse their academic week via an intuitive horizontal date pager or quickly jump to any specific date using a native modal date picker.
- Automatic Week Alternation: Designed with modern academic cycles in mind, the app automatically tracks and alternates between current weeks (e.g., Week A / Week B structures) based on the active schedule configuration.
- Daily Agenda Overview: Displays a clear, scannable list of today's classes, showing total class counts and precise start times at a glance.

### Anatomy of a Class Card: Each contextual card presents a wealth of information including:
- Subject Title
- Class Type (e.g., Lecture, Lab)
- Assigned Instructor/Teacher
- Physical or Virtual Classroom location
- Exact Start and End timestamps
- Inline Management: Tapping on any individual class card opens an inline editor allowing users to instantly modify class parameters, alter timetables, or remove the entry entirely.

Custom Class Types: Right from the Home dashboard, users can tap the 'Custom' button to create brand-new categories of classes, defining specialized names, custom iconography, and specific color tags.

## 2. Tasks & Assignments Manager
The Tasks Tab provides a robust, high-granularity task-tracking system designed to replace external to-do lists and prevent missed deadlines.
### Task Metadata: Every task created within Studija supports a comprehensive set of properties:
- Title: Concise name of the assignment or homework.
- Deadline: Context-aware date and time picker for submission tracking.
- Notes: A dedicated rich-text area for detailed instructions, hints, or links.
- Priority Matrix: Visual priority flags to separate low-stakes reading from critical exams.

Academic Binding: Tasks can be explicitly linked to a specific Subject. This relational binding allows for future contextual filtering.
Smart Archiving: Completed tasks don't just disappear; checking them off instantly moves them into a dedicated, collapsible 'Completed' Section, keeping the active workspace clean while preserving an archive of past achievements.

## 3. Settings & Data Hierarchy Control
The Settings Tab acts as the configuration layer of Studija, providing deep access to the underlying relational database structures through three main entry points:

- A. Schedules Management
This section handles the top-level organizational layer. Users can browse, create, edit, and delete entire schedule profiles.
- Active Status: Seamlessly toggle which schedule is currently driving the main Home dashboard.
- Nested Week Configuration: Inside each individual schedule, users can manage its constituent weeks. Weeks can be added, deleted, or manually toggled as the active target, providing extreme flexibility for chaotic university timetables.
- Note: To keep configuration lean, schedules and weeks are managed via clean, single-field text identifiers.

- B. Subjects Registry
A centralized database of all academic disciplines.
- Full CRUD capabilities for individual subjects.
- Each subject is assigned a unique title and a distinct semantic color, which propagates across the app to visually unify tasks, classes, and schedules.

- C. Class Types Configuration
Manages the visual metadata associated with daily events. The application establishes a clear boundary between core system presets and user generated content:
- System Presets: By default, Studija includes three immutable, hardcoded class types: Lecture, Lab, and Seminar. To ensure database integrity, these system defaults cannot be edited or deleted.
- User Custom Types: Custom types enjoy full CRUD capabilities. Users can completely customize the title, choose from an array of system symbols (SF Symbols compatible), and pick colors from an adaptive palette.

# Requirements Document

## Introduction

This document outlines the requirements for a repair guiding app scaffold that provides users with a structured interface to access repair guides, upload content, and manage their profile. The app will feature a tab-based navigation system with five main sections: Home, Search, My Guides, Manual Upload, and Profile. This initial implementation focuses on creating the UI skeleton and navigation structure without backend functionality.

## Requirements

### Requirement 1

**User Story:** As a user, I want to navigate between different sections of the app using a bottom tab bar, so that I can easily access all main features.

#### Acceptance Criteria

1. WHEN the app launches THEN the system SHALL display a bottom navigation bar with five tabs: Home, Search, My Guides, Manual Upload, and Profile and the Home tab SHALL be selected by default. Use material icons.
2. WHEN a user taps on any tab THEN the system SHALL switch to the corresponding screen
3. WHEN a tab is selected THEN the system SHALL highlight the active tab by changing it's icon and label color to the app's primary brown theme. The inactive tabs SHALL appear in a muted shade (e.g. lighter brown). Label's SHALL always be visible
4. WHEN navigating between tabs THEN the system SHALL preserve each tab's state including scroll position, entered form data and previous naviagtion stack within that tab (Implementation: use IndexedStack or equivalent persistence approach in Flutter)

### Requirement 2

**User Story:** As a user, I want to see a welcoming home screen with recently opened guides, so that I can quickly access content I've been working with.

#### Acceptance Criteria

1. WHEN the user opens the Home tab THEN the system SHALL display a welcome message like "We're here to guide you step by step" (Implementation: message SHALL be configurable so it can be updated in the future)
2. WHEN the Home tab loads THEN the system SHALL show a section for recently opened guides. The section SHALL have a clear title such as “Recent Guides”
3. WHEN there are no recent guides THEN the system SHALL display an appropriate empty state message "No recent guides yet. Start exploring to see them here!"
(Optional: include a placeholder illustration or icon to make the empty state visually friendly)
4. WHEN recent guides exist THEN the system SHALL display them in a scrollable list or grid format 
5. Each guide item SHALL include: Guide title, Thumbnail or placeholder image (if backend not yet integrated) and Last opened date/time (optional but useful for context)
6. For development/testing, the system SHALL use placeholder dummy guide data (title, thumbnail, date) until backend is integrated.
7. The system SHALL store recent guides locally first (using local storage)
8. The system SHALL later support syncing recent guides with backend (placeholder API integration point must be included in code for easy extension)
9. Tapping on a guide SHALL open it in the My Guides tab (or corresponding screen)
10. A button SHALL exist on the Guide to have it removed from the recent guides list.

### Requirement 3

**User Story:** As a user, I want to search solutions and browse repair guides by categories, so that I can find the specific guidance I need.

#### Acceptance Criteria

1. WHEN the user opens the Search tab THEN the system SHALL display a search bar at the top of the screen
2. WHEN the Search tab loads THEN the system SHALL show repair guides organized in categories and subcategories
3. WHEN categories are displayed THEN the system SHALL support hierarchical navigation through categories, subcategories, and sub-subcategories
4. WHEN the user taps on a category THEN the system SHALL navigate to show its subcategories or guides
5. WHEN the search bar is used THEN the system SHALL provide a placeholder for future search functionality
6. WHEN the user enters a query into the search bar and presses the Search button, THEN the system SHALL search within the Supabase database of repair guides and display matching results (dummy placeholder for now)
7. The search bar SHALL include a secondary button (e.g., “Search Web”) at the end of the input field. WHEN the user presses this button THEN the system SHALL provide a placeholder area indicating that results would be fetched from external sources like Google or YouTube.
8. For this release, both Supabase and external search results SHALL be mocked with placeholder/dummy data, but the UI SHALL be structured to allow smooth integration of actual APIs later.
9. The system SHALL NOT perform real search yet but SHALL be structured so that a future search service (e.g., YouTube API, Google Custom Search, or backend API) can be integrated without redesigning the UI

### Requirement 4

**User Story:** As a user, I want to access and manage my saved or bookmarked repair guides, so that I can quickly return to them and track my progress.

#### Acceptance Criteria

1. WHEN the user opens the My Guides tab THEN the system SHALL display a list of guides the user has saved/bookmarked/previously been working on.
2. WHEN there are no saved guides THEN the system SHALL show an empty state with a message like: “No saved guides yet. Search and bookmark guides to access them here.”
3. WHEN guides exist THEN the system SHALL display them in a scrollable list/grid with: Guide title, Guide thumbnail image (or placeholder icon if no image), Progress indicator (e.g., “3 of 7 steps completed”), Last accessed date/time
4. The user SHALL be able to remove/unbookmark guides from the list.
5. WHEN a guide is selected THEN the system SHALL navigate to a placeholder “Guide Detail View” screen.
6. The tab SHALL preserve the state of saved guides across app sessions (even if only dummy data now).

### Requirement 5

**User Story:** As a user, I want to interact with a chatbot that helps me understand repair manuals, so that I can ask questions naturally and also upload and interact with product manuals, so that I can better understand the instructions and troubleshoot my items.

#### Acceptance Criteria

1. WHEN the user opens the Manuals & Chat tab THEN the system SHALL display a chatbot interface (chat messages area + text input field).
2. WHEN no interaction has started THEN the system SHALL display a welcome message like: “Hi! Upload your product manual or ask me any repair question.”
3. WHEN the user sends a message THEN the system SHALL display it in the chat area and provide a placeholder for the chatbot response.
4. WHEN the user uploads a manual (image, PDF, or camera scan) THEN the system SHALL attach it to the conversation and show it as a “manual card” in the chat.
5. WHEN a manual is attached THEN the system SHALL provide placeholder actions:
“Translate to text” (future: OCR + translation API)
“Play as audio” (future: text-to-speech API)
“Ask about this manual” (future: RAG chatbot over uploaded file)
6. The system SHALL preserve the chat history and uploaded manuals locally (for now, placeholders with dummy data).

### Requirement 6

**User Story:** As a user, I want to view and manage my profile and app settings, so that I can customize my experience and manage my account.

#### Acceptance Criteria

1. WHEN the user opens the Profile tab THEN the system SHALL display user information including profile picture, display name, and email.
2. WHEN the user is not logged in THEN the system SHALL display a “Sign in / Sign up” placeholder instead of profile details.
3. WHEN the Profile tab loads THEN the system SHALL show app settings at minimum:
Light/Dark mode toggle, Notifications toggle (placeholder only), Language preference (placeholder only)
3. WHEN settings are displayed THEN the system SHALL include security options section with placeholders for: Change Password, Logout, and Delete Account.
4. WHEN the profile loads THEN the system SHALL show placeholder content for logged-in user information
5. WHEN the dark mode toggle is used THEN the system SHALL immediately switch between the predefined schemeLight and schemeDark color schemes, applied globally across the app. The theme preference SHALL not persist between app sessions at this stage.
6. WHEN the dark mode toggle is used THEN the system SHALL persist the choice so that it remains on next app launch.
7. WHEN profile content is not yet fully implemented THEN the system SHALL display placeholder sections for future account details.

### Requirement 7

**User Story:** As a user, I want the app to have a consistent and intuitive design, so that I can easily navigate and use all features.

#### Acceptance Criteria

1. WHEN the app is used THEN the system SHALL apply the defined color schemes (schemeLight and schemeDark) consistently across all tabs and screens.
2. WHEN any screen loads THEN the system SHALL use appropriate Flutter Material Design components with the app’s custom theme applied
3. WHEN the app is displayed THEN the system SHALL allow switching between light and dark themes using the global toggle in the Profile tab
4. WHEN navigation occurs THEN the system SHALL provide smooth transitions between screens
5. WHEN the app runs THEN the system SHALL be responsive to different screen sizes
6. WHEN placeholder content is displayed THEN the system SHALL follow the same styling as real content, ensuring consistency during development
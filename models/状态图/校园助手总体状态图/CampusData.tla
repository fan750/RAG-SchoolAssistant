----------------------------- MODULE CampusData -----------------------------
VARIABLES document, calendar, library, access

vars == <<document, calendar, library, access>>

LibraryBasics == {"Hours", "OfficialBookingLink"}
DayTypes == {"Workday", "Weekend", "Holiday"}

Init ==
    /\ document = [phase |-> "Waiting", approved |-> FALSE, visible |-> FALSE]
    /\ calendar = [dayType |-> "Unknown", source |-> "None"]
    /\ library = [authorized |-> FALSE, queried |-> FALSE, fields |-> LibraryBasics]
    /\ access = [page |-> "CampusWeb", signedIn |-> FALSE]

SyncPublicSources ==
    /\ document.phase = "Waiting"
    /\ document' = [document EXCEPT !.phase = "Review"]
    /\ UNCHANGED <<calendar, library, access>>

PublishReviewedContent ==
    /\ document.phase = "Review"
    /\ document' = [phase |-> "Published", approved |-> TRUE, visible |-> TRUE]
    /\ UNCHANGED <<calendar, library, access>>

ReadCalendarAPI ==
    /\ calendar.dayType = "Unknown"
    /\ \E kind \in DayTypes:
        calendar' = [dayType |-> kind, source |-> "TongjiCalendarAPI"]
    /\ UNCHANGED <<document, library, access>>

ConfirmSeatAccess ==
    /\ ~library.authorized
    /\ library' = [library EXCEPT !.authorized = TRUE]
    /\ UNCHANGED <<document, calendar, access>>

ReadLiveSeats ==
    /\ library.authorized
    /\ ~library.queried
    /\ library' = [library EXCEPT
        !.queried = TRUE,
        !.fields = LibraryBasics \cup {"ReservableSeats", "SampleTime"}]
    /\ UNCHANGED <<document, calendar, access>>

BrowsePublicInfo ==
    /\ access.page = "CampusWeb"
    /\ access' = [access EXCEPT !.page = "PublicInfo"]
    /\ UNCHANGED <<document, calendar, library>>

SignIn ==
    /\ access.page = "CampusWeb"
    /\ access' = [page |-> "SignedIn", signedIn |-> TRUE]
    /\ UNCHANGED <<document, calendar, library>>

AskAgent ==
    /\ access.page = "SignedIn"
    /\ access.signedIn
    /\ access' = [access EXCEPT !.page = "Answer"]
    /\ UNCHANGED <<document, calendar, library>>

Done ==
    /\ document.visible
    /\ calendar.dayType \in DayTypes
    /\ library.queried
    /\ access.page \in {"PublicInfo", "Answer"}
    /\ UNCHANGED vars

Next ==
    SyncPublicSources \/ PublishReviewedContent \/ ReadCalendarAPI
    \/ ConfirmSeatAccess \/ ReadLiveSeats
    \/ BrowsePublicInfo \/ SignIn \/ AskAgent \/ Done

OnlyReviewedContentIsVisible ==
    document.visible => document.approved

CalendarComesFromOfficialAPI ==
    calendar.dayType # "Unknown" =>
        calendar.dayType \in DayTypes /\ calendar.source = "TongjiCalendarAPI"

LibraryShowsBasics ==
    LibraryBasics \subseteq library.fields

NoSeatQueryBeforeAuthorization ==
    ~library.authorized => ~library.queried /\ library.fields = LibraryBasics

SeatCountComesWithSampleTime ==
    "ReservableSeats" \in library.fields =>
        library.authorized /\ library.queried /\ "SampleTime" \in library.fields

OnlySignedInUsersCanAsk ==
    access.page = "Answer" => access.signedIn
=============================================================================

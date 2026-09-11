## Ransack

- https://github.com/SoniaDumitru/ransack-predicates

## TicketTracker - Writeup

- [Polyglot SVG/PDF - arbitrary file read](./polyglot.svg)
- https://elweth.fr/writeups/Root-Me_-_XMAS_2025/Day_11_-_TicketTracker
    
```txt
Mass Assignment: Exploitation of params.permit! and User.new(user_params) to self-validate during registration
Type Confusion in Marcel + Ghostscript abuse: Uploading a PostScript file disguised as a PDF that executes arbitrary code via Ghostscript to list /tmp and retrieve session files
Account Takeover: Hijacking of admin session via exposed session files
SQL Injection (Order By): Exploitation of an SQLi in the sort parameter to exfiltrate the admin password containing the flag
``` 

### Ghostscript abuse

- https://www.synacktiv.com/publications/playing-with-imagetragick-like-its-2016


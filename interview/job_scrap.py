#!/usr/bin/env python3

"""
HPC Job Scraper - Fast, accurate job scraping for France.
Based on https://github.com/speedyapply/JobSpy
"""

from jobspy import scrape_jobs
import pandas as pd
from datetime import datetime
import os
import time
import argparse
import csv
import re
import sys


# ==========================
# DEFAULT CONFIGURATION
# ==========================

DEFAULT_KEYWORDS = ["HPC", "IA", "Slurm", "Linux", "Kubernetes"]

DEFAULT_LOCATIONS = [
    "Paris",
    "Grenoble",
    "Toulouse",
    "Rennes",
    "Saclay",
]

JOB_SITES = ["linkedin", "indeed"]

TARGET_COMPANIES = [
    "GENCI", "CEA", "CNRS", "Inria", "IDRIS", "CINES", "Atos", "Eviden"
]

# Hours presets
HOURS_PRESETS = {
    "1day": 24,
    "3days": 72,
    "1week": 168,
}


# ==========================
# TEXT SANITIZATION
# ==========================

def sanitize_text(text):
    """Clean text for CSV: remove newlines, collapse spaces."""
    if not isinstance(text, str):
        return str(text) if text is not None else ""
    text = re.sub(r'\s+', ' ', text)
    return text.strip()


def sanitize_dataframe(df):
    """Sanitize all string columns for clean CSV export."""
    text_columns = [
        'title', 'company', 'location', 'description', 'job_type',
        'company_industry', 'company_description', 'company_addresses',
        'skills', 'job_level', 'job_function', 'listing_type', 'emails',
        'company_url', 'company_logo', 'job_url', 'job_url_direct',
        'work_from_home_type', 'salary_source', 'interval', 'currency'
    ]
    for col in text_columns:
        if col in df.columns:
            df[col] = df[col].apply(sanitize_text)
    return df


# ==========================
# SCORING SYSTEM
# ==========================

def score_job(row):
    """Score jobs based on HPC/IA relevance."""
    score = 0
    text = (
        str(row.get("title", "")) + " " +
        str(row.get("company", "")) + " " +
        str(row.get("description", ""))
    ).lower()

    tech_stack = {
        "hpc": 5,
        "slurm": 5,
        "cluster": 4,
        "supercalcul": 5,
        "gpu": 4,
        "nvidia": 3,
        "infiniband": 4,
        "lustre": 4,
        "ia ": 4,
        "intelligence artificielle": 5,
        "deep learning": 4,
        "pytorch": 3,
        "tensorflow": 3,
        "linux": 2,
        "kubernetes": 3,
        "docker": 2,
    }

    for tech, value in tech_stack.items():
        if tech in text:
            score += value

    for company in TARGET_COMPANIES:
        if company.lower() in text:
            score += 5

    return score


# ==========================
# SCRAPER
# ==========================

def run_search(keywords, locations, results_per_search, hours_old, job_type, is_remote, verbose=True):
    """
    Run job search with given keywords and locations.
    Returns deduplicated DataFrame.
    """
    all_jobs = []
    total_searches = len(keywords) * len(locations)
    count = 0

    for keyword in keywords:
        for location in locations:
            count += 1
            if verbose:
                print(f"[{count}/{total_searches}] {keyword} @ {location}...", end=" ", flush=True)

            try:
                jobs = scrape_jobs(
                    site_name=JOB_SITES,
                    search_term=keyword,
                    location=location,
                    results_wanted=results_per_search,
                    hours_old=hours_old,
                    country_indeed="France",
                    job_type=job_type,
                    is_remote=is_remote,
                    verbose=2 if verbose else 0,
                )

                if jobs is not None and not jobs.empty:
                    all_jobs.append(jobs)
                    if verbose:
                        print(f"+{len(jobs)} jobs")
                else:
                    if verbose:
                        print("0 jobs")

            except Exception as e:
                if verbose:
                    print(f"error: {e}")

            time.sleep(0.3)  # Minimal delay

    if not all_jobs:
        return None

    # Efficient merge: concat once, then deduplicate
    df = pd.concat(all_jobs, ignore_index=True)
    
    # Deduplicate by unique job identifiers
    if 'job_url_direct' in df.columns:
        df.drop_duplicates(subset=['job_url_direct'], inplace=True)
    else:
        df.drop_duplicates(subset=['title', 'company', 'location'], inplace=True)

    return df


# ==========================
# EXPORT
# ==========================

def export_results(df, top50_only=False):
    """Export results with proper CSV formatting."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    os.makedirs("results", exist_ok=True)

    suffix = "_top50" if top50_only else "_full"
    base_path = f"results/hpc_jobs{suffix}_{timestamp}.csv"

    df_export = df.head(50) if top50_only else df
    df_export.to_csv(base_path, index=False, quoting=csv.QUOTE_ALL, lineterminator="\n")

    print(f"\n✓ Saved: {base_path}")
    print(f"  Rows: {len(df_export)}")
    return base_path


# ==========================
# MAIN
# ==========================

def main():
    parser = argparse.ArgumentParser(
        description="⚡ Fast HPC/IA Job Scraper for France",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scrap.py                      # Quick top50 with defaults
  python scrap.py --full               # Full scrape with defaults
  python scrap.py -k HPC IA Calcul     # Custom keywords
  python scrap.py -k "HPC Engineer"    # Quoted multi-word keyword
  python scrap.py -l Paris Lyon        # Custom locations
  python scrap.py -k HPC -l Paris      # Single keyword + location
  python scrap.py --hours 1day         # Jobs from last 24h
  python scrap.py --remote             # Remote jobs only
        """
    )

    parser.add_argument(
        "-k", "--keywords",
        nargs="+",
        default=None,
        help=f"Search keywords (default: {' '.join(DEFAULT_KEYWORDS)})"
    )
    parser.add_argument(
        "-l", "--locations",
        nargs="+",
        default=None,
        help=f"Locations (default: {' '.join(DEFAULT_LOCATIONS)})"
    )
    parser.add_argument(
        "--full",
        action="store_true",
        help="Scrape all jobs (default: top 50 only)"
    )
    parser.add_argument(
        "--top50",
        action="store_true",
        help="Export only top 50 jobs (default behavior)"
    )
    parser.add_argument(
        "-n", "--num-results",
        type=int,
        default=25,
        help="Results per search (default: 25)"
    )
    parser.add_argument(
        "--hours",
        type=str,
        default="3days",
        choices=["1day", "3days", "1week"],
        help="Job age filter (default: 3days)"
    )
    parser.add_argument(
        "--remote",
        action="store_true",
        help="Remote jobs only (default: on-site)"
    )
    parser.add_argument(
        "--job-type",
        type=str,
        default="fulltime",
        choices=["fulltime", "parttime", "internship", "contract"],
        help="Job type (default: fulltime)"
    )
    parser.add_argument(
        "--quiet", "-q",
        action="store_true",
        help="Suppress progress output"
    )

    # Show help if no arguments
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(0)

    args = parser.parse_args()

    # Resolve keywords and locations
    keywords = args.keywords if args.keywords else DEFAULT_KEYWORDS
    locations = args.locations if args.locations else DEFAULT_LOCATIONS

    # Resolve hours
    hours_old = HOURS_PRESETS.get(args.hours, 72)

    # Determine export mode
    top50_only = args.top50 or not args.full

    print("\n" + "=" * 50)
    print("⚡  HPC/IA Job Scraper - France")
    print("=" * 50)
    print(f"Keywords: {', '.join(keywords)}")
    print(f"Locations: {', '.join(locations)}")
    print(f"Job Type: {args.job_type}")
    print(f"Remote: {'Yes' if args.remote else 'No (on-site)'}")
    print(f"Hours Old: {args.hours} ({hours_old}h)")
    print(f"Mode: {'FULL' if not top50_only else 'TOP50'}")
    print("=" * 50 + "\n")

    df = run_search(
        keywords=keywords,
        locations=locations,
        results_per_search=args.num_results,
        hours_old=hours_old,
        job_type=args.job_type,
        is_remote=args.remote,
        verbose=not args.quiet
    )

    if df is None:
        print("\n✗ No jobs found.")
        sys.exit(1)

    print(f"\n✓ Total raw jobs: {len(df)}")

    # Score and sort
    print("Scoring jobs...")
    df["score"] = df.apply(score_job, axis=1)
    df.sort_values(by="score", ascending=False, inplace=True)

    # Sanitize for clean CSV
    df = sanitize_dataframe(df)

    # Preview
    print("\n📊 Top 10 jobs:")
    print(df[["title", "company", "location", "score"]].head(10).to_string(index=False))

    # Export
    export_results(df, top50_only=top50_only)


if __name__ == "__main__":
    main()

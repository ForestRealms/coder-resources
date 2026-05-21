#!/usr/bin/env python3
"""
Coder Template Delete Script
Delete all templates defined in JSON configuration.

Usage:
  python delete_templates.py                  # Delete all templates
  python delete_templates.py node            # Delete specific template
  python delete_templates.py -h              # Show help
  python delete_templates.py -l              # List templates
  python delete_templates.py -c config.json  # Use custom config
  python delete_templates.py --dry-run       # Preview deletions
"""

import argparse
import json
import subprocess
import sys
from typing import Dict, Any, List

DEFAULT_CONFIG = "templates.json"


def load_config(config_path: str = DEFAULT_CONFIG) -> Dict[str, Any]:
    """Load template configuration from JSON file."""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Config file '{config_path}' not found")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid config format - {e}")
        sys.exit(1)


def list_templates(config: Dict[str, Any]) -> None:
    """Display all available templates in config."""
    print("\nTemplates defined in configuration:")
    print("-" * 50)
    for key, info in config.items():
        display_name = info.get('display_name', 'N/A')
        print(f"  {key:30} - {display_name}")
    print()


def check_coder() -> bool:
    """Verify coder CLI is installed and accessible."""
    try:
        subprocess.run(
            ["coder", "--version"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def delete_template(template_name: str, dry_run: bool = False) -> bool:
    """Delete a single template using coder CLI."""
    if dry_run:
        print(f"[DRY RUN] Would delete template: {template_name}")
        return True

    print(f"Deleting template: {template_name}")

    try:
        cmd = f"coder templates delete {template_name} --yes"
        result = subprocess.run(
            cmd,
            shell=True,
            text=True,
            capture_output=True
        )

        if result.returncode == 0:
            print(f"✅ Successfully deleted: {template_name}")
            if result.stdout:
                print(result.stdout)
            return True
        else:
            print(f"❌ Failed to delete {template_name}")
            if result.stderr:
                print(f"Error: {result.stderr}")
            return False

    except Exception as e:
        print(f"❌ Error deleting {template_name}: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Delete Coder templates defined in JSON configuration",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""Examples:
  %(prog)s                    # Delete all templates
  %(prog)s node              # Delete 'node' template
  %(prog)s -l                # List all templates
  %(prog)s -c config.json    # Use custom config file
  %(prog)s --dry-run         # Preview deletions (dry-run mode)
"""
    )

    parser.add_argument(
        "template",
        nargs="?",
        help="Specific template to delete (delete all if omitted)"
    )

    parser.add_argument(
        "-c", "--config",
        default=DEFAULT_CONFIG,
        help=f"Config file path (default: {DEFAULT_CONFIG})"
    )

    parser.add_argument(
        "-l", "--list",
        action="store_true",
        help="List available templates without deleting"
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview deletions without executing (dry-run mode)"
    )

    args = parser.parse_args()

    # Load configuration
    templates = load_config(args.config)

    # Verify coder CLI
    if not check_coder() and not args.dry_run and not args.list:
        print("Error: 'coder' command not found. Please install Coder CLI.")
        sys.exit(1)

    # List templates if requested
    if args.list:
        list_templates(templates)
        return

    # Determine which templates to delete
    if args.template:
        if args.template in templates:
            templates_to_delete = {args.template: templates[args.template]}
        else:
            print(f"Template '{args.template}' not found in config. Available templates:")
            for key in templates:
                print(f"  - {key}")
            sys.exit(1)
    else:
        templates_to_delete = templates

    if not templates_to_delete:
        print("No templates to delete")
        return

    # Get template names
    template_names = list(templates_to_delete.keys())
    template_count = len(template_names)

    # Show action summary
    if args.dry_run:
        print(f"\nDRY RUN MODE: Would delete {template_count} template(s)")
    else:
        print(f"\nDeleting {template_count} template(s)")

    print("=" * 50)

    # Execute deletions
    success_count = 0
    for name in template_names:
        if delete_template(name, dry_run=args.dry_run):
            success_count += 1

    # Show summary
    print(f"\n{'=' * 50}")
    print("SUMMARY")
    print(f"{'=' * 50}")

    if args.dry_run:
        print(f"Preview complete: {template_count} template(s) would be deleted")
    else:
        print(f"Deleted: {success_count}/{template_count} template(s)")
        if success_count < template_count:
            print(f"Failed: {template_count - success_count} template(s)")


if __name__ == "__main__":
    main()
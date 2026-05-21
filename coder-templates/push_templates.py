#!/usr/bin/env python3
"""
Coder Template Pusher
Push and update Coder templates with metadata from JSON configuration.

Usage:
  python push_templates.py                 # Push all templates
  python push_templates.py node           # Push single template
  python push_templates.py -h             # Show help
  python push_templates.py -l             # List all templates
  python push_templates.py -c config.json # Use custom config
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Dict, Any, Optional, Tuple

DEFAULT_CONFIG = "templates.json"
DEFAULT_VARS_FILE = "production.yml"


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
    """Display all available templates."""
    print("\nAvailable Templates:")
    print("-" * 50)
    for key, info in config.items():
        print(f"  {key:30} - {info.get('display_name', 'N/A')}")
    print()


def run_cmd(cmd: str) -> Tuple[bool, Optional[str]]:
    """Execute shell command with output to console."""
    print(f"Running: {cmd}")

    try:
        # 直接运行，不捕获输出，让输出直接显示在控制台
        result = subprocess.run(
            cmd,
            shell=True,
            check=True
        )
        return True, None
    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}")
        return False, f"Exit code: {e.returncode}"
    except Exception as e:
        error_msg = f"Command execution error: {e}"
        print(f"❌ {error_msg}")
        return False, error_msg


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


def push_template(name: str, info: Dict[str, Any], vars_file: str) -> bool:
    """Push and update a single template."""
    print(f"\n{'=' * 50}")
    print(f"Processing: {name}")
    print(f"{'=' * 50}")

    # Validate template directory exists
    template_dir = Path(".") / name
    if not template_dir.exists() or not template_dir.is_dir():
        print(f"⚠️  Skipping: Directory '{name}' not found")
        return False

    # Check variables file
    vars_path = Path(".") / vars_file
    if not vars_path.exists():
        print(f"⚠️  Variables file '{vars_file}' not found")
        cont = input("Continue anyway? (y/N): ")
        if cont.lower() != 'y':
            return False

    # Push template
    push_cmd = f"coder templates push {name} --directory {name}"
    if vars_path.exists():
        push_cmd += f" --variables-file {vars_file}"
    push_cmd += " --yes"

    print(f"Executing: {push_cmd}")
    success, output = run_cmd(push_cmd)
    if not success:
        print(f"Failed: {output}")
        return False

    # Update metadata
    print(f"Updating metadata: {name}")

    display_name = info.get("display_name", name)
    description = info.get("description", "")
    icon = info.get("icon", "")

    edit_cmd = f"coder templates edit {name}"
    if display_name:
        edit_cmd += f' --display-name "{display_name}"'
    if description:
        edit_cmd += f' --description "{description}"'
    if icon:
        edit_cmd += f' --icon "{icon}"'

    success, output = run_cmd(edit_cmd)
    if success:
        print(f"✅ Template '{name}' pushed successfully")
    else:
        print(f"❌ Failed to update metadata: {output}")

    return success


def dry_run(name: str, info: Dict[str, Any], vars_file: str) -> None:
    """Preview what would be executed without actually running commands."""
    print(f"\nTemplate: {name}")
    print(f"  Directory: ./{name}")
    print(f"  Variables: {vars_file}")
    print(f"  Display Name: {info.get('display_name', 'N/A')}")
    print(f"  Description: {info.get('description', 'N/A')[:50]}...")


def main():
    parser = argparse.ArgumentParser(
        description="Coder Template Pusher",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""Examples:
  %(prog)s                    # Push all templates
  %(prog)s node              # Push 'node' template
  %(prog)s -l                # List all templates
  %(prog)s -c config.json    # Use custom config file
"""
    )

    parser.add_argument(
        "template",
        nargs="?",
        help="Template name to push (all if omitted)"
    )

    parser.add_argument(
        "-c", "--config",
        default=DEFAULT_CONFIG,
        help=f"Config file path (default: {DEFAULT_CONFIG})"
    )

    parser.add_argument(
        "-l", "--list",
        action="store_true",
        help="List available templates"
    )

    parser.add_argument(
        "-v", "--variables",
        default=DEFAULT_VARS_FILE,
        help=f"Variables file (default: {DEFAULT_VARS_FILE})"
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview actions without executing"
    )

    args = parser.parse_args()

    # Load configuration
    templates = load_config(args.config)

    # Verify coder CLI
    if not check_coder():
        print("Error: 'coder' command not found. Please install Coder CLI.")
        sys.exit(1)

    # List templates if requested
    if args.list:
        list_templates(templates)
        return

    # Determine which templates to process
    if args.template:
        if args.template in templates:
            targets = {args.template: templates[args.template]}
        else:
            # Silent skip for non-existent template
            targets = {}
    else:
        targets = templates

    # Dry run mode
    if args.dry_run:
        print("DRY RUN - No changes will be made")
        print("=" * 50)
        for name, info in targets.items():
            dry_run(name, info, args.variables)
        return

    # Process templates
    if not targets:
        print("No templates to process")
        return

    success = []
    failed = []

    for name, info in targets.items():
        if push_template(name, info, args.variables):
            success.append(name)
        else:
            failed.append(name)

    # Summary
    print(f"\n{'=' * 50}")
    print("SUMMARY")
    print(f"{'=' * 50}")
    if success:
        print(f"✅ Success: {len(success)} templates")
        for name in success:
            print(f"  - {name}")
    if failed:
        print(f"❌ Failed: {len(failed)} templates")
        for name in failed:
            print(f"  - {name}")


if __name__ == "__main__":
    main()
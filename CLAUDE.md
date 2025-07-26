# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

mdformat-myst is a Python plugin for mdformat that enables formatting of MyST (Markedly Structured Text) markdown files. It extends mdformat with MyST-specific syntax including directives, roles, math expressions, comments, and block breaks.

## Development Commands

### Testing
- `pytest` - Run all tests
- `pytest tests/test_mdformat_myst.py` - Run main test suite
- `tox -e py38` - Run tests in isolated environment
- `coverage run -m pytest && coverage report` - Run tests with coverage

### Code Quality
- `black .` - Format code
- `isort .` - Sort imports
- `flake8` - Lint code
- `mypy mdformat_myst` - Type checking
- `pre-commit run --all-files` - Run all pre-commit hooks

### Building
- `pip install -e .` - Install in development mode
- `pip install -e .[test,dev]` - Install with test/dev dependencies

## Core Architecture

### Plugin Entry Point
- `mdformat_myst/plugin.py` contains the main plugin implementation
- `update_mdit()` configures markdown-it parser with MyST extensions
- `RENDERERS` dict maps token types to rendering functions
- `POSTPROCESSORS` dict handles text escaping for MyST syntax

### Key Components
1. **Parser Extensions Integration**: Automatically enables dependent plugins (tables, frontmatter, footnote)
2. **MyST Syntax Support**: Implements renderers for roles, directives, math, comments, targets
3. **Directive Processing**: `_directives.py` handles MyST directive formatting with YAML option parsing
4. **Text Escaping**: Prevents conflicts between CommonMark and MyST syntax

### MyST Token Types
- `myst_role` - Inline roles like `{role}content`
- `myst_line_comment` - Lines starting with `%`
- `myst_block_break` - `+++` separators
- `myst_target` - `(target)=` labels
- `math_inline`/`math_block` - Dollar math syntax
- `fence` - Code blocks and directives

### Testing Strategy
- Fixture-based testing using `tests/data/fixtures.md`
- Tests both API (`mdformat.text()`) and CLI interfaces
- CommonMark compliance testing in `test_commonmark_compliancy.py`

## Development Notes

### Dependencies
- Core: `mdformat`, `mdit-py-plugins`, `mdformat-tables`, `mdformat-frontmatter`, `mdformat-footnote`
- YAML processing: `ruamel.yaml` for directive option formatting
- Testing: `pytest`, `coverage`

### Plugin Architecture
The plugin follows mdformat's extension pattern:
1. Parser extension modifies markdown-it instance
2. Renderers convert AST nodes to MyST syntax
3. Postprocessors escape conflicting syntax in text nodes

### Critical Implementation Details
- Directive content formatting preserves YAML structure in directive options
- Text escaping prevents MyST syntax from being interpreted in regular text
- HTML rendering is disabled for code blocks to bypass AST validation
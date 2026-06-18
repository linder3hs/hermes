#!/usr/bin/env node

const fs = require('fs')
const path = require('path')

const cwd = process.env.CLAUDE_PROJECT_ROOT || process.cwd()
const hasPackageJson = fs.existsSync(path.join(cwd, 'package.json'))
const hasCLAUDEMd = fs.existsSync(path.join(cwd, 'CLAUDE.md'))
const isEmpty = fs.readdirSync(cwd).filter(f => !f.startsWith('.')).length === 0

if (isEmpty) {
  console.log('🪽 Hermes ready. Empty directory detected.')
  console.log('Run /new-project to start building — or /new-project [preset] for a quick start.')
  console.log('Presets: minimal · saas · ai-app · dashboard · marketing')
} else if (hasPackageJson) {
  const pkg = JSON.parse(fs.readFileSync(path.join(cwd, 'package.json'), 'utf8'))
  const name = pkg.name || 'this project'
  console.log(`🪽 Hermes ready. Existing project detected: ${name}`)
  if (!hasCLAUDEMd) {
    console.log('No CLAUDE.md found. Run /project-health to analyze and generate one.')
  } else {
    console.log('Run /project-health to check for gaps or add services.')
  }
} else {
  console.log('🪽 Hermes ready.')
  console.log('Run /new-project to create a project or /project-health to analyze an existing one.')
}

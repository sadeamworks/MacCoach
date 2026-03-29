# Fastlane for Mac Coach

## Installation

1. Install Bundler (if not already installed):
   ```bash
   gem install bundler
   ```

2. Install Fastlane dependencies:
   ```bash
   cd fastlane
   bundle install
   ```

## Available Lanes

| Lane | Description | Usage |
|------|-------------|-------|
| `build` | Build debug version locally | `bundle exec fastlane build` |
| `test` | Run unit tests | `bundle exec fastlane test` |
| `dist` | Build for distribution | `bundle exec fastlane dist` |
| `release_build` | Build .pkg for App Store Connect | `bundle exec fastlane release_build` |
| `release` | Bump version + build + prepare for upload | `bundle exec fastlane release` |
| `verify` | Verify code signing certificates | `bundle exec fastlane verify` |

## Release Workflow

1. Bump version in `project.yml`:
   - Update `MARKETING_VERSION` (e.g., "1.0.0" → "1.0.1")
   - Update `CURRENT_PROJECT_VERSION` (e.g., "1" → "2")

2. Regenerate Xcode project:
   ```bash
   xcodegen generate
   ```

3. Build release:
   ```bash
   cd fastlane && bundle exec fastlane release_build
   ```

4. Upload to App Store Connect:
   - Go to App Store Connect → Mac Coach → "Builds"
   - Upload `./build/MacCoach.pkg`
   - Fill in version information
   - Submit for review

## Code Signing

Mac Coach uses automatic code signing managed by Xcode:
- Set up in `project.yml` under `entitlements`
- App Sandbox enabled: `com.apple.security.app-sandbox: true`

### Manual Certificate Setup (if needed)

For App Store distribution, you need:
1. **Mac Installer Distribution Certificate** (for distributing .pkg)
2. **Mac App Store Certificate** (for app signing)
3. **Provisioning Profile** (created automatically by Xcode)

These are managed in:
- [Apple Developer → Certificates](https://developer.apple.com/account/resources/certificates/list)
- [App Store Connect → Mac Coach](https://appstoreconnect.apple.com)

## GitHub Actions (Optional)

The `.github/workflows/deploy.yml` workflow automatically builds on tag push:
```bash
git tag v1.0.1
git push --tags
```

See `.github/workflows/deploy.yml` for configuration.

## Notes

- Mac apps **do not use TestFlight** — there's no beta testing platform for macOS
- Use `fastlane release_build` to generate the .pkg file
- Upload .pkg manually to App Store Connect for review
- Always test the built .pkg on a clean Mac before submitting

# Supabase Setup Guide

## Configuration

Your Supabase project has been configured with the following credentials:

- **Project ID**: `odbenfbmqgyxpclklpux`
- **URL**: `https://odbenfbmqgyxpclklpux.supabase.co`
- **Publishable Key**: `sb_publishable_wIcsEx7Dul2waf7OPbRnEw_cFp-KABb`

⚠️ **IMPORTANT**: The secret key should NEVER be used in client applications. It's for server-side use only.

## Database Schema

The database schema has been created in `supabase/migrations/001_create_messages_schema.sql`. 

To apply the migration:

1. **Using Supabase CLI** (recommended):
   ```bash
   supabase db push
   ```

2. **Using Supabase Dashboard**:
   - Go to SQL Editor in your Supabase dashboard
   - Copy the contents of `supabase/migrations/001_create_messages_schema.sql`
   - Paste and run in the SQL Editor

## Tables Created

- `user_profiles` - User profile information linked to Supabase Auth
- `conversations` - Conversation/thread management
- `messages` - Chat message history with hierarchical structure

All tables have Row Level Security (RLS) enabled with policies that ensure users can only access their own data.

## Next Steps

### 1. Install Supabase Swift SDK

Add the Supabase Swift package to your Xcode project:

1. In Xcode, go to File → Add Package Dependencies
2. Enter: `https://github.com/supabase/supabase-swift`
3. Select the latest version
4. Add to your target

### 2. Update SupabaseConfig.swift

Once the SDK is installed, update `cbc/Config/SupabaseConfig.swift`:

```swift
import Supabase

// Update the client property:
private(set) var client: SupabaseClient?

// Update initialization:
self.client = SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
```

### 3. Configure Sign in with Apple in Supabase

1. Go to Authentication → Providers in Supabase Dashboard
2. Enable "Apple" provider
3. Configure with your Apple Developer credentials:
   - Service ID
   - Team ID
   - Key ID
   - Private Key

### 4. Enable Realtime

1. Go to Database → Replication in Supabase Dashboard
2. Enable replication for the `messages` table
3. This allows real-time updates across devices

### 5. Test the Integration

1. Build and run the app
2. Try Sign in with Apple
3. Send a test message
4. Verify it appears in Supabase dashboard under the `messages` table

## Security Notes

- ✅ Publishable key is safe to use in client apps
- ❌ Secret key should NEVER be in client code
- ✅ RLS policies protect user data
- ✅ Session tokens stored in Keychain (secure)
- ✅ Apple ID tokens validated server-side

## Troubleshooting

### "Supabase client not configured"
- Check that `SupabaseConfig.swift` has the correct URL and key
- Verify the configuration is loaded in `cbcApp.swift` init

### "Authentication failed"
- Verify Sign in with Apple is configured in Supabase
- Check Apple Developer credentials are correct
- Ensure entitlements file includes Sign in with Apple capability

### "Messages not syncing"
- Check Supabase Realtime is enabled for messages table
- Verify RLS policies allow user to read/write their messages
- Check network connectivity

## Files Modified

- `cbc/Config/SupabaseConfig.swift` - Configuration with your credentials
- `cbc/cbc.entitlements` - Added Sign in with Apple capability
- `supabase/migrations/001_create_messages_schema.sql` - Database schema

## Architecture

- **Primary Database**: Supabase PostgreSQL
- **Offline Cache**: CloudKit (Apple devices)
- **Real-time Sync**: Supabase Realtime subscriptions
- **Authentication**: Sign in with Apple → Supabase Auth

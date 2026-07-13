-- ===== 在 Supabase SQL Editor 中执行以下全部语句 =====

-- 1. 用户扩展表（性别 + 加密密钥）
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  gender TEXT NOT NULL CHECK (gender IN ('male', 'female')),
  encryption_key TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 录制记录表（加密存储）
CREATE TABLE IF NOT EXISTS recordings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  encrypted_transcript TEXT,
  encrypted_metadata TEXT,
  video_storage_path TEXT,
  iv TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. RLS 策略：用户只能访问自己的数据
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE recordings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select_own" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "recordings_select_own" ON recordings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "recordings_insert_own" ON recordings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "recordings_delete_own" ON recordings FOR DELETE USING (auth.uid() = user_id);

-- 4. 新用户注册时自动创建 profiles 行（触发器）
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, gender, encryption_key)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'gender', NEW.raw_user_meta_data->>'encryption_key');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ========================================
-- 5. 存储桶 RLS 策略（SQL Editor 中执行有完整权限）
-- ========================================
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS users_select_own ON storage.objects;
CREATE POLICY users_select_own ON storage.objects
  FOR SELECT USING ((auth.uid())::text = owner_id);

DROP POLICY IF EXISTS users_insert_own ON storage.objects;
CREATE POLICY users_insert_own ON storage.objects
  FOR INSERT WITH CHECK ((auth.uid())::text = owner_id);

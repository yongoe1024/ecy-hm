import { preferences } from '@kit.ArkData';

const PREFERENCES_NAME: string = 'ECY_APP';

/**
 * 用户首选项
 **/
export class PreferenceManager {
  private dataPreferences?: preferences.Preferences;
  private context = getContext(this)
  private static instance: PreferenceManager;

  constructor() {
    this.initPreferenceSync(PREFERENCES_NAME);
  }

  public static getInstance(): PreferenceManager {
    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager();
    }
    return PreferenceManager.instance;
  }

  initPreferenceSync(storeName: string) {
    let options: preferences.Options = { name: storeName }
    let temp = preferences.getPreferencesSync(this.context, options)
    this.dataPreferences = temp
  }

  async initPreference(storeName: string): Promise<void> {
    return preferences.getPreferences(this.context, storeName)
      .then((preferences: preferences.Preferences) => {
        this.dataPreferences = preferences;
      });
  }

  putSync<T>(key: string, value: T) {
    this.dataPreferences?.putSync(key, JSON.stringify(value))
    this.save()
  }

  async put<T>(key: string, value: T): Promise<void> {
    if (this.dataPreferences) {
      this.dataPreferences.put(key, JSON.stringify(value)).then(() => {
        this.save();
      })
    } else {
      this.initPreference(PREFERENCES_NAME).then(() => {
        this.put<T>(key, value);
      });
    }
  }

  getSync<T>(key: string): T | null {
    let res: preferences.ValueType | undefined = this.dataPreferences?.getSync(key, '')
    if (res) {
      return JSON.parse(res as string) as T;
    }
    return null;
  }

  async get<T>(key: string): Promise<T | null> {
    if (this.dataPreferences) {
      return this.dataPreferences.get(key, '').then((res: preferences.ValueType) => {
        let value: T | null = null;
        if (res) {
          value = JSON.parse(res as string) as T;
        }
        return value;
      });
    } else {
      return this.initPreference(PREFERENCES_NAME).then(() => {
        return this.get<T>(key);
      });
    }
  }

  hasSync(key: string): boolean {
    return this.dataPreferences ? this.dataPreferences.hasSync(key) : false
  }

  async has(key: string): Promise<boolean> {
    if (this.dataPreferences) {
      return this.dataPreferences.has(key);
    } else {
      return this.initPreference(PREFERENCES_NAME).then(() => {
        return this.has(key);
      });
    }
  }

  deleteSync(key: string) {
    this.dataPreferences?.deleteSync(key)
  }

  async delete(key: string): Promise<void> {
    if (this.dataPreferences) {
      this.dataPreferences.delete(key).then(() => {
        this.save();
      });
    } else {
      this.initPreference(PREFERENCES_NAME).then(() => {
        this.delete(key);
      });
    }
  }

  save() {
    this.dataPreferences?.flush();
  }
}
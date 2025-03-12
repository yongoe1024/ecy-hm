import { fileIo, fileUri } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';

/**
 * 文件工具
 */
export class FileUtils {
  /**
   * 获取URI，可用于Image等
   */
  public static getUriByPath(path: string) {
    return fileUri.getUriFromPath(path);
  }

  /**
   * 删除文件
   */
  public static remove(path: string) {
    fileIo.unlink(path);
  }

  /**
   * 复制文件
   */
  public static copy(sourcePath: string, path: string) {
    let pathIO = fileIo.openSync(sourcePath, fileIo.OpenMode.READ_ONLY)
    fileIo.copyFileSync(pathIO.fd, path)
    fileIo.closeSync(pathIO);
  }

  /**
   * 保存文件 by 字符串
   */
  public static saveByString(path: string, buffer: string) {
    // 创建，文件存在就重写
    let file = fileIo.openSync(path, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
    try {
      fileIo.writeSync(file.fd, buffer)
    } finally {
      fileIo.closeSync(file);
    }
  }

  /**
   * 保存文件 by ArrayBuffer
   */
  public static saveByArrayBuffer(path: string, buffer: ArrayBuffer) {
    // 创建，文件存在就重写
    let file = fileIo.openSync(path, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
    try {
      fileIo.writeSync(file.fd, buffer)
    } finally {
      fileIo.closeSync(file);
    }
  }

  /**
   * 读文件到ArrayBuffer
   */
  public static readArrayBuffer(path: string): ArrayBuffer {
    const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY);
    const fileInfo = fileIo.statSync(file.fd) // 读取文件的具体信息
    // 声明buffer的数组
    const buffer = new ArrayBuffer(fileInfo.size) // 空的buffer 有长度
    fileIo.readSync(file.fd, buffer) // 把图片的文件 => buffer
    fileIo.closeSync(file.fd) // 关闭文件
    return buffer
  }

  /**
   * 读取文件（获取string）
   */
  public static readString(path: string, encoding: string = 'utf-8'): string {
    let buffer = FileUtils.readArrayBuffer(path)
    let uint8 = new Uint8Array(buffer);
    let textDecoder = util.TextDecoder.create('utf-8');
    let retStr = textDecoder.decodeToString(uint8, { stream: false });
    return retStr;
  }


  /**
   * internal协议，将文件复制到缓存，重命名uuid，
   * 得到 internal://cache/
   */
  public static copyToCache(path: string) {
    let dir = getContext().cacheDir
    let type = path.split('.').pop()
    let uuidName = util.generateRandomUUID() + '.' + type
    let pathIO = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY)
    fileIo.copyFileSync(pathIO.fd, `${dir}/${uuidName}`)
    fileIo.closeSync(pathIO);
    return `internal://cache/${uuidName}`
  }
}
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';

/**
 * 返回参数
 */
class CompressedImageInfo {
  imageUri: string = ""; // 压缩后图片保存位置的uri
  imageByteLength: number = 0; // 压缩后图片字节长度
}

/**
 * 压缩工具
 */
export class ImageUtils {
  /**
   * 图片压缩，保存
   * @param sourcePixelMap：原始待压缩图片的PixelMap对象
   * @param maxSize：指定图片的压缩目标大小，单位kb
   * @returns compressedImageInfo：返回最终压缩后的图片信息
   */
  public static async compressedImage(sourcePixelMap: image.PixelMap, maxSize: number): Promise<CompressedImageInfo> {
    // 创建图像编码ImagePacker对象
    const imagePackerApi = image.createImagePacker();
    const IMAGE_QUALITY = 0;
    const packOpts: image.PackingOption = { format: "image/jpeg", quality: IMAGE_QUALITY };
    // 通过PixelMap进行编码。compressedImageData为打包获取到的图片文件流。
    let compressedImageData: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
    // 压缩目标图像字节长度
    const maxCompressedImageByte = maxSize * 1024;
    // 图片压缩。先判断设置图片质量参数quality为0时，packing能压缩到的图片最小字节大小是否满足指定的图片压缩大小。如果满足，则使用packing方式二分查找最接近指定图片压缩目标大小的quality来压缩图片。如果不满足，则使用scale对图片先进行缩放，采用while循环每次递减0.4倍缩放图片，再用packing（图片质量参数quality设置0）获取压缩图片大小，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据。
    if (maxCompressedImageByte > compressedImageData.byteLength) {
      // 使用packing二分压缩获取图片文件流
      compressedImageData =
        await ImageUtils.packingImage(compressedImageData, sourcePixelMap, IMAGE_QUALITY, maxCompressedImageByte);
    } else {
      // 使用scale对图片先进行缩放，采用while循环每次递减0.4倍缩放图片，再用packing（图片质量参数quality设置0）获取压缩图片大小，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据
      let imageScale = 1;
      const REDUCE_SCALE = 0.4;
      // 判断压缩后的图片大小是否大于指定图片的压缩目标大小，如果大于，继续降低缩放倍数压缩。
      while (compressedImageData.byteLength > maxCompressedImageByte) {
        if (imageScale > 0) {
          // 性能知识点: 由于scale会直接修改图片PixelMap数据，所以不适用二分查找scale缩放倍数。这里采用循环递减0.4倍缩放图片，来查找确定最适合的缩放倍数。如果对图片压缩质量要求不高，建议调高每次递减的缩放倍数reduceScale，减少循环，提升scale压缩性能。
          imageScale = imageScale - REDUCE_SCALE;
          await sourcePixelMap.scale(imageScale, imageScale);
          compressedImageData = await ImageUtils.packing(sourcePixelMap, IMAGE_QUALITY);
        } else {
          // imageScale缩放小于等于0时，没有意义，结束压缩。这里不考虑图片缩放倍数小于reduceScale的情况。
          break;
        }
      }
    }
    // 保存图片，返回压缩后的图片信息。
    const compressedImageInfo: CompressedImageInfo = await ImageUtils.saveImage(compressedImageData);
    return compressedImageInfo;
  }

  /**
   * packing压缩
   * @param sourcePixelMap：原始待压缩图片的PixelMap
   * @param imageQuality：图片质量参数
   * @returns data：返回压缩后的图片数据
   */
 private  static async packing(sourcePixelMap: image.PixelMap, imageQuality: number): Promise<ArrayBuffer> {
    const imagePackerApi = image.createImagePacker();
    const packOpts: image.PackingOption = { format: "image/jpeg", quality: imageQuality };
    const data: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
    return data;
  }

  /**
   * packing二分方式循环压缩
   * @param compressedImageData：图片压缩的ArrayBuffer
   * @param sourcePixelMap：原始待压缩图片的PixelMap
   * @param imageQuality：图片质量参数
   * @param maxCompressedImageByte：压缩目标图像字节长度
   * @returns compressedImageData：返回二分packing压缩后的图片数据
   */
  private static async packingImage(compressedImageData: ArrayBuffer, sourcePixelMap: image.PixelMap,
    imageQuality: number, maxCompressedImageByte: number): Promise<ArrayBuffer> {
    // 图片质量参数范围为0-100，这里以10为最小二分单位创建用于packing二分图片质量参数的数组。
    const packingArray: number[] = [];
    const DICHOTOMY_ACCURACY = 10;
    // 性能知识点: 如果对图片压缩质量要求不高，建议调高最小二分单位dichotomyAccuracy，减少循环，提升packing压缩性能。
    for (let i = 0; i <= 100; i += DICHOTOMY_ACCURACY) {
      packingArray.push(i);
    }
    let left = 0;
    let right = packingArray.length - 1;
    // 二分压缩图片
    while (left <= right) {
      const mid = Math.floor((left + right) / 2);
      imageQuality = packingArray[mid];
      // 根据传入的图片质量参数进行packing压缩，返回压缩后的图片文件流数据。
      compressedImageData = await ImageUtils.packing(sourcePixelMap, imageQuality);
      // 判断查找一个尽可能接近但不超过压缩目标的压缩大小
      if (compressedImageData.byteLength <= maxCompressedImageByte) {
        left = mid + 1;
        if (mid === packingArray.length - 1) {
          break;
        }
        // 获取下一次二分的图片质量参数（mid+1）压缩的图片文件流数据
        compressedImageData = await ImageUtils.packing(sourcePixelMap, packingArray[mid + 1]);
        // 判断用下一次图片质量参数（mid+1）压缩的图片大小是否大于指定图片的压缩目标大小。如果大于，说明当前图片质量参数（mid）压缩出来的图片大小最接近指定图片的压缩目标大小。传入当前图片质量参数mid，得到最终目标图片压缩数据。
        if (compressedImageData.byteLength > maxCompressedImageByte) {
          compressedImageData = await ImageUtils.packing(sourcePixelMap, packingArray[mid]);
          break;
        }
      } else {
        // 目标值不在当前范围的右半部分，将搜索范围的右边界向左移动，以缩小搜索范围并继续在下一次迭代中查找左半部分。
        right = mid - 1;
      }
    }
    return compressedImageData;
  }

  /**
   * 图片保存
   * @param compressedImageData：压缩后的图片数据
   * @returns compressedImageInfo：返回压缩后的图片信息
   */
  private static async saveImage(compressedImageData: ArrayBuffer): Promise<CompressedImageInfo> {
    const context: Context = getContext();
    // 定义要保存的压缩图片uri。afterCompressiona.jpeg表示压缩后的图片。
    const compressedImageUri: string = context.filesDir + '/' + 'afterCompressiona.jpeg';
    try {
      const res = fileIo.accessSync(compressedImageUri);
      if (res) {
        // 如果图片afterCompressiona.jpeg已存在，则删除
        fileIo.unlinkSync(compressedImageUri);
      }
    } catch (err) {
      console.error(`AccessSync failed with error message: ${err.message}, error code: ${err.code}`);
    }
    // 知识点：保存图片。获取最终图片压缩数据compressedImageData，保存图片。
    // 压缩图片数据写入文件
    const file: fileIo.File = fileIo.openSync(compressedImageUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    fileIo.writeSync(file.fd, compressedImageData);
    fileIo.closeSync(file);
    // 获取压缩图片信息
    let compressedImageInfo: CompressedImageInfo = new CompressedImageInfo();
    compressedImageInfo.imageUri = compressedImageUri;
    compressedImageInfo.imageByteLength = compressedImageData.byteLength;
    return compressedImageInfo;
  }
}
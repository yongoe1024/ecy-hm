import { ComponentContent } from "@kit.ArkUI";
import { camera, cameraPicker } from "@kit.CameraKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";

/**
 * 构造参数
 */
export class ActionSheetDialogModel {
  actions: string[] = []
  onSelect: (index: number) => void = () => {
  }
  // 内部参数，禁用
  close?: () => void;
}

/**
 * 动作面板弹窗
 */
export class ActionSheetDialog {
  private constructor() {
  }

  /**
   * 打开弹窗
   */
  public static show(context: UIContext, model: ActionSheetDialogModel) {
    const contentNode = new ComponentContent(context, wrapBuilder(ActionSheetBuilder), model);
    const promptAction = context.getPromptAction();

    model.close = async () => {
      await promptAction.closeCustomDialog(contentNode);
      contentNode.dispose()
    }

    promptAction.openCustomDialog(contentNode, {
      alignment: DialogAlignment.Bottom,
      autoCancel: true,
      isModal: true,
    });
  }

  /**
   * 相册 & 拍照 选择
   */
  public static selectImage(context: UIContext, onSelect: (imgPath: string) => void) {
    ActionSheetDialog.show(context, {
      actions: ['拍照', '相册'], onSelect: async (index: number) => {
        if (index == 0) {
          const result = await cameraPicker.pick(getContext(), [cameraPicker.PickerMediaType.PHOTO],
            { cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK })
          onSelect(result.resultUri)
        } else if (index == 1) {
          const picker = new photoAccessHelper.PhotoViewPicker()
          const result = await picker.select({
            maxSelectNumber: 1,
            MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
          })
          onSelect(result.photoUris[0])
        }
      }
    })
  }
}

/**
 * 动作面板builder
 */
@Builder
export function ActionSheetBuilder(model: ActionSheetDialogModel) {
  Column() {
    ForEach(model.actions, (item: string, index: number) => {
      Text(item)
        .width('100%')
        .height(60)
        .textAlign(TextAlign.Center)
        .border({
          width: { bottom: model.actions.length - 1 === index ? 5 : 1 },
          color: { bottom: "#E5E5E5" }
        })
        .onClick(() => {
          model.onSelect && model.onSelect(index)
        })
    })
    Text('取消')
      .width('100%')
      .textAlign(TextAlign.Center)
      .height(60)
      .onClick(() => {
        model.close && model.close()
      })
  }
  .width('100%')
  .backgroundColor(Color.White)
  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
}

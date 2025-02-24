import { ComponentContent } from "@kit.ArkUI";

/**
 * 自定义 toast 弹窗
 */
export class ToastBuilderModel {
  message: ResourceStr = ""
  delayToHideTime: number = 2000
  closeListener?: () => void;
}

@Builder
export function ToastBuilder(model: ToastBuilderModel) {
  Column() {
    if (model.message) {
      Text(model.message)
        .fontSize((14))
        .fontColor('#fff')
        .backgroundColor(Color.Transparent)
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .enabled(false)
    } else {
      Text("错误")
        .fontSize((14))
        .fontColor('#fff')
        .backgroundColor(Color.Transparent)
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .enabled(false)
    }
  }
  .width('auto')
  .padding(16)
  .height('auto')
  .backgroundColor('#000')
  .borderRadius(0)
  .margin({
    left: 20,
    right: 20
  })
  .onAppear(() => {
    if (model.delayToHideTime !== undefined) {
      setTimeout(() => {
        model.closeListener?.();
      }, model.delayToHideTime)
    }
  })
}

export class ToastUtil {
  static readonly TAG = 'ToastUtil'

  private constructor() {
  }

  public static showToast(context: UIContext, msg: ResourceStr, duration: number = 2000) {
    const model: ToastBuilderModel = new ToastBuilderModel()
    model.message = msg
    model.delayToHideTime = duration
    const contentNode = new ComponentContent(context, wrapBuilder(ToastBuilder), model);
    const promptAction = context.getPromptAction();

    model.closeListener = () => {
      promptAction.closeCustomDialog(contentNode);
    }

    promptAction.openCustomDialog(contentNode, {
      alignment: DialogAlignment.Center,
      autoCancel: false,
      isModal: false,
      showInSubWindow: true,
    });
  }
}

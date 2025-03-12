import { NavDesModifier } from "./NavDestinationModifier";
import { TextOneModifier, TextThreeModifier, TextTwoModifier } from "./TextModifier";


export class GlobalStyle {
  static navModifier = new NavDesModifier()

  static textModifier = (size: 'big' | 'normal' | 'small', type: 1 | 2 | 3) => {
    let sizeNum: 1 | 2 | 3 = size == 'big' ? 1 : size == 'normal' ? 2 : 3
    if (type == 1) {
      return new TextOneModifier(sizeNum)
    } else if (type == 2) {
      return new TextTwoModifier(sizeNum)
    } else {
      return new TextThreeModifier(sizeNum)
    }
  }
}
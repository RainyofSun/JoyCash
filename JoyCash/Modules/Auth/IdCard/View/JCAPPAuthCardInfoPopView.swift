//
//  JCAPPAuthCardInfoPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/25.
//

import UIKit

class JCAPPAuthCardInfoPopView: JCAPPBasePopView {

    open var JCAPPsaveParams: [String: String] = [:]
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg4")
    }
    
    @discardableResult
    public func JCAPPreloadCardInfoSource(_ source: [JCAPPRecognitionModel], tipText: String?, tipTitle: String?) -> Self {
        
        self.JCAPPpopTitleLab.text = tipTitle
        
        var _temp_top: JCAPPAuthCardInfoUnitView?
        source.enumerated().forEach { (idx: Int, item: JCAPPRecognitionModel) in
            let isLast: Bool = idx == source.count - 1
            let unitModel: JCAPPAuthInfoUnitModel = JCAPPAuthInfoUnitModel()
            unitModel.defects = isLast ? "incidenta" : "incidentb"
            unitModel.graphic = item.injuries
            unitModel.video = item.safe
            unitModel.prize = item.prize
            if let _key = unitModel.prize {
                self.JCAPPsaveParams[_key] = unitModel.video
            }
            
            let view = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
            view.unitDelegate = self
            view.JCAPPsetInfoUnitModel(unitModel, unitRightImage: (isLast ? UIImage(named: "pop_down_arrow") : nil))
            self.JCAPPcontentView.addSubview(view)
            
            if let _top = _temp_top {
                if isLast {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 4)
                        make.horizontalEdges.equalTo(_top)
                        make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 4)
                        make.horizontalEdges.equalTo(_top)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(APP_PADDING_UNIT)
                    make.horizontalEdges.equalToSuperview()
                }
            }
            
            _temp_top = view
        }
        
        return self
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPAuthCardInfoPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

extension JCAPPAuthCardInfoPopView: APPAuthCardInfoUnitProtocol {
    func JCAPPtouchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView) {
        guard itemView.input_type == .Input_Enum else {
            return
        }
        
        guard let _super_view = self.superview, let _key = itemView.JCAPPunitTupe?.cacheKey else {
            return
        }
        
        let timeView = JCAPPTimeSelectedPopView(frame: UIScreen.main.bounds, showCloseButton: true)
        timeView.alpha = .zero
        _super_view.addSubview(timeView)
        
        timeView.clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
            guard let _t_v = popView as? JCAPPTimeSelectedPopView, let _time = _t_v.JCAPPselectedDate else {
                return
            }
            
            self?.JCAPPsaveParams[_key] = _time
            itemView.JCAPPreloadUnitInfoText(_time)
            
            UIView.transition(with: popView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                popView.alpha = .zero
            }) { _ in
                self?.alpha = 1
                popView.removeFromSuperview()
            }
        }
        
        timeView.popDidmissClosure = { [weak self] (popView: JCAPPBasePopView) in
            UIView.transition(with: popView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                popView.alpha = .zero
            }) { _ in
                self?.alpha = 1
                popView.removeFromSuperview()
            }
        }
        
        UIView.transition(with: timeView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            timeView.alpha = 1
        }) { _ in
            self.alpha = .zero
        }
    }
    
    func JCAPPdidEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?) {
        guard let _key = itemView.JCAPPunitTupe?.cacheKey else {
            return
        }
        
        self.JCAPPsaveParams[_key] = inputValue
    }
}

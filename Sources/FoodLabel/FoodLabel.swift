import SwiftUI
import SwiftHaptics
import PrepUnits
import FoodLabelScanner

extension FoodLabelDataSource {
    var shouldShowMicronutrients: Bool {
        !nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
    }
    
    var shouldShowCustomMicronutrients: Bool {
        //TODO: Fix this when custom micros are brought back
        false
    }
    
    func nutrientAmount(for type: NutrientType) -> Double? {
        nutrients[type]
    }
}

//public struct FoodLabel<DataSource: FoodLabelDataSource>: View {
public struct FoodLabel<DataSource>: View where DataSource: FoodLabelDataSource {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var viewModel: DataSource

    @State var showingEnergyInCalories: Bool

    public init(dataSource: DataSource) {
        self.viewModel = dataSource
        _showingEnergyInCalories = State(initialValue: dataSource.energyValue.unit != FoodLabelUnit.kj)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            calories
            if viewModel.showRDAValues {
                Spacer().frame(height: 3)
            }
            macros
            if viewModel.shouldShowMicronutrients {
                macrosMicrosSeparator
                micros
            }
            if viewModel.shouldShowCustomMicronutrients {
                microsCustomSeparator
                customMicros
            }
            if viewModel.showFooterText {
                footer
            }
        }
        .padding(15)
        .border(borderColor, width: 5.0)
    }
}

public struct FoodLabelPreview: View {
    
    class ViewModel: ObservableObject {
        
    }

    @StateObject var viewModel = ViewModel()
    public var body: some View {
        FoodLabel(dataSource: viewModel)
            .frame(width: 350)
    }
    public init() { }
}

extension FoodLabelPreview.ViewModel: FoodLabelDataSource {
    var amountPerString: String {
        "1 serving (1 cup, chopped)"
    }
    
    var nutrients: [NutrientType : Double] {
        [
            .saturatedFat: 5,
            .addedSugars: 35
        ]
    }
    
    var showRDAValues: Bool {
        false
    }
    
    var showFooterText: Bool {
        false
    }
    
    var energyValue: FoodLabelValue {
        FoodLabelValue(amount: 235, unit: .kj)
    }
    
    var carbAmount: Double {
        45
    }
    
    var fatAmount: Double {
        8
    }
    
    var proteinAmount: Double {
        12
    }
}

struct FoodLabel_Previews: PreviewProvider {
    static var previews: some View {
        FoodLabelPreview()
    }
}

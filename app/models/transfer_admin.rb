require './app/models/demand.rb'

class TransferAdmin < Demand
  KEYS = %i(i01 i02 i021 i03 i04 i05
            i06 i07 i08 i09 i10
            i11 i12
            )

  extend  DelayedSave

end

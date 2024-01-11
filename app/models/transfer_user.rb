require './app/models/demand.rb'

class TransferUser < Demand
  KEYS = %i(i01 i02
            s03 s04 s05 s06 s07 s08 s08_
            t03 t04 t05 t06 t07 t08 t09 t10 t11 t11_
            p03
            )

  extend  DelayedSave

end

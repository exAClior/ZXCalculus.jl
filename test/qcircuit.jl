using ZXCalculus, Test

qc = random_circuit(4, 100)
@test gate_count(qc) == 100
qc = QCircuit(4)
push_gate!(qc, Val{:Sdag}(), 1)
push_gate!(qc, Val{:H}(), 1)
push_gate!(qc, Val{:S}(), 1)
push_gate!(qc, Val{:S}(), 2)
push_gate!(qc, Val{:H}(), 4)
push_gate!(qc, Val{:CNOT}(), 3, 2)
push_gate!(qc, Val{:CZ}(), 4, 1)
push_gate!(qc, Val{:H}(), 2)
push_gate!(qc, Val{:T}(), 2)
push_gate!(qc, Val{:CNOT}(), 3, 2)
push_gate!(qc, Val{:Tdag}(), 2)
push_gate!(qc, Val{:CNOT}(), 1, 4)
push_gate!(qc, Val{:H}(), 1)
push_gate!(qc, Val{:T}(), 2)
push_gate!(qc, Val{:S}(), 3)
push_gate!(qc, Val{:H}(), 4)
push_gate!(qc, Val{:T}(), 1)
push_gate!(qc, Val{:H}(), 2)
push_gate!(qc, Val{:H}(), 3)
push_gate!(qc, Val{:Sdag}(), 4)
push_gate!(qc, Val{:S}(), 3)
push_gate!(qc, Val{:X}(), 4)
push_gate!(qc, Val{:CNOT}(), 3, 2)
push_gate!(qc, Val{:H}(), 1)
push_gate!(qc, Val{:S}(), 4)
push_gate!(qc, Val{:X}(), 4)

circ = ZXDiagram(qc)
@test tcount(qc) == tcount(circ)
pt_circ = phase_teleportation(circ)
@test tcount(pt_circ) <= tcount(circ)
pt_qc = QCircuit(pt_circ)
@test tcount(pt_qc) == tcount(pt_circ)
@test gate_count(pt_qc) <= gate_count(qc)

ex_circ = clifford_simplification(circ)
ex_qc = QCircuit(ex_circ)
@test tcount(ex_circ) == tcount(ex_qc)

qc_id = [qc qc']
zxd_id = ZXDiagram(qc_id)
zxd_id = phase_teleportation(zxd_id)
for _ = 1:5
    global zxd_id = clifford_simplification(zxd_id)
end
@test ZXCalculus.nv(zxd_id) == 8

# encoding: utf-8

module Journey
  module NFA
    module Dot
      def to_dot
        edges = transitions.map { |from, sym, to|
          "  #{from} -> #{to} [label=\"#{sym || 'ε'}\"];"
        }

        #memo_nodes = memos.values.flatten.map { |n|
        #  label = n
        #  if Journey::Route === n
        #    label = "#{n.verb.source} #{n.path.spec}"
        #  end
        #  "  #{n.object_id} [label=\"#{label}\", shape=box];"
        #}
        #memo_edges = memos.map { |k, memos|
        #  (memos || []).map { |v| "  #{k} -> #{v.object_id};" }
        #}.flatten.uniq

        <<-eodot
digraph nfa {
  rankdir=LR;
  node [shape = doublecircle];
  #{accepting_states.join ' '};
  node [shape = circle];
#{edges.join "\n"}
}
        eodot
      end
    end
  end
end

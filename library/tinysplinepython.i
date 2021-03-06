%module tinysplinepython

// Map std::vector<tinyspline::real> to Python list.
%typemap(out) std::vector<tinyspline::real> * (int size, PyObject *data) {
	size = $1->size();
	$result = PyList_New(size);
	for (int i = 0; i < size; i++) {
		data = PyFloat_FromDouble((*$1)[i]);
		PyList_SetItem($result, i, data);
	}
}

// Map Python list to std::vector<tinyspline::real>.
%typemap(in) std::vector<tinyspline::real> * (int size, PyObject *data) %{
	size = PyList_Size($input);
	$1 = new std::vector<tinyspline::real>();
	$1->reserve(size);
	for (int i = 0; i < size; i++) {
		data = PyList_GetItem($input, i);
		$1->push_back(PyFloat_AsDouble(data));
	}
%}

// Cleanup memory allocated by typemaps.
%typemap(freearg) std::vector<tinyspline::real> * {
	delete $1;
}

//********************************************************
//*                                                      *
//* BSpline (Python)                                     *
//*                                                      *
//********************************************************
%ignore tinyspline::BSpline::operator=;

%feature("pythonprepend") tinyspline::BSpline::BSpline %{
"""
__init__(self) -> BSpline
__init__(self, other) -> BSpline
__init__(self, deg, dim, nCtrlp, type) -> BSpline
__init__(self, points, dim) -> BSpline
"""
%}

//********************************************************
//*                                                      *
//* DeBoorNet (Python)                                   *
//*                                                      *
//********************************************************
%ignore tinyspline::DeBoorNet::operator=;

//********************************************************
//*                                                      *
//* SWIG base file                                       *
//*                                                      *
//********************************************************
%include "tinyspline.i"
